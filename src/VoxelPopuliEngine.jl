module VoxelPopuliEngine
using ExtraFun

include("./scene/Scene.jl")

struct Engine
  
end

"""
Instantiate and run a game engine instance. The passed callback receives the initialized `Engine`.
"""
function run(cb)
  engine = init(Engine())
  cb(engine)
  close(engine)
end

function ExtraFun.init(engine::Engine)
  
  engine
end

function Base.close(engine::Engine)
  
  engine
end

end # module VoxelPopuliEngine
