#################### Dependent Methods ####################

function Base.show(io::IO, d::Dependent)
  msg = string(ifelse(length(d.monitor) > 0, "A ", "An un"),
               "monitored node of type \"", summary(d), "\"\n")
  print(io, msg)
  show(io, d.value)
end

function Base.showall(io::IO, d::Dependent)
  show(io, d)
  print(io, "\nFunction:\n")
  show(io, d.eval.code)
  print(io, "\n\nSource Nodes:\n")
  show(io, d.sources)
  print(io, "\n\nTarget Nodes:\n")
  show(io, d.targets)
end

invlink(d::Dependent, x, transform::Bool=true) = x

link(d::Dependent, x, transform::Bool=true) = x

logpdf(d::Dependent, transform::Bool=false) = 0.0

function names(d::Dependent)
  names(d, d.symbol)
end

function setmonitor!(d::Dependent, monitor::Bool)
  value = monitor ? Int[0] : Int[]
  setmonitor!(d, value)
end

function setmonitor!(d::Dependent, monitor::Vector{Int})
  values = monitor
  d.nlink = length(link(d, d.value, false))
  if d.nlink > 0 && length(monitor) > 0
    if monitor[1] == 0
      values = [1:d.nlink]
    elseif minimum(monitor) < 1 || maximum(monitor) > d.nlink
      throw(BoundsError())
    end
  end
  d.monitor = values
  d
end


#################### Logical Constructors ####################

function Logical(value, expr::Expr, monitor::Union(Bool,Vector{Int}))
  d = Logical(value, :nothing, 0, Int[], depfx(expr), depsrc(expr), Symbol[])
  setmonitor!(d, monitor)
end

function Logical(expr::Expr, monitor::Union(Bool,Vector{Int})=true)
  value = convert(VariateType, NaN)
  Logical(value, expr, monitor)
end

function Logical(d::Integer, expr::Expr, monitor::Union(Bool,Vector{Int})=true)
  value = Array(VariateType, tuple(zeros(Integer, d)...))
  Logical(value, expr, monitor)
end



#################### Logical Methods ####################

function setinits!(l::Logical, m::Model, ::Any=nothing)
  l.value = l.eval(m)
  setmonitor!(l, l.monitor)
end

function update!(l::Logical, m::Model)
  l[:] = l.eval(m)
  l
end


#################### Stochastic Constructors ####################

function Stochastic(value, expr::Expr, monitor::Union(Bool,Vector{Int}))
  d = Stochastic(value, :nothing, 0, Int[], depfx(expr), depsrc(expr), Symbol[],
                 NullDistribution())
  setmonitor!(d, monitor)
end

function Stochastic(expr::Expr, monitor::Union(Bool,Vector{Int})=true)
  value = convert(VariateType, NaN)
  Stochastic(value, expr, monitor)
end

function Stochastic(d::Integer, expr::Expr,
                    monitor::Union(Bool,Vector{Int})=true)
  value = Array(VariateType, tuple(zeros(Integer, d)...))
  Stochastic(value, expr, monitor)
end


#################### Stochastic Methods ####################

function Base.showall(io::IO, s::Stochastic)
  show(io, s)
  print(io, "\n\nDistribution:\n")
  show(io, s.distr)
  print(io, "\nFunction:\n")
  show(io, s.eval.code)
  print(io, "\n\nSource Nodes:\n")
  show(io, s.sources)
  print(io, "\n\nTarget Nodes:\n")
  show(io, s.targets)
end

function setinits!(s::Stochastic, m::Model, x)
  T = typeof(s.value)
  s.value = isa(x, T) ? copy(x) : convert(T, x)
  s.distr = s.eval(m)
  if isa(s.distr, Array) && size(s.value) != size(s.distr)
    error("size of stochastic node and Distributions array must match")
  end
  setmonitor!(s, s.monitor)
end

insupport(s::Stochastic) = all(mapdistr(insupport, s, s.value))

function invlink(s::Stochastic, x, transform::Bool=true)
  f(d, x) = invlink(d, x, transform)
  mapdistr(f, s, x)
end

function link(s::Stochastic, x, transform::Bool=true)
  f(d, x) = link(d, x, transform)
  mapdistr(f, s, x)
end

function logpdf(s::Stochastic, transform::Bool=false)
  f(d, x) = logpdf(d, x, transform)
  sum(mapdistr(f, s, s.value))
end

function mapdistr(f::Function, s::Stochastic, x)
  if isa(s.distr, Array)
    y = similar(x)
    for i in 1:length(y)
      y[i] = f(s.distr[i], x[i])
    end
    y
  else
    f(s.distr, x)
  end
end

function update!(s::Stochastic, m::Model)
  s.distr = s.eval(m)
  s
end


#################### Utility Functions ####################

function depsrc(expr::Expr)
  if expr.head == :ref && expr.args[1] == :model && isa(expr.args[2], QuoteNode)
    Symbol[expr.args[2].value]
  else
    mapreduce(depsrc, union, expr.args)
  end
end

function depsrc(expr)
  Symbol[]
end

function depfx(expr::Expr)
  eval(Expr(:function, :(model::Mamba.Model,), expr))
end
