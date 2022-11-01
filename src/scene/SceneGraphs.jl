module SceneGraphs
import StaticArrays: @SMatrix
using ExtraFun
using ..Math

export SceneGraph
"""The abstract scene graph is a N-tree of arbitrary entities. Each entity must have a `SceneGraphNode`-compatible
scene node carrying information on its position within the graph as well as certain relevant rendering data."""
struct SceneGraph
  roots::Set
end

function ExtraFun.update!(graph::SceneGraph)
  throw("not yet implemented")
end

"""The standard component to integrate arbitrary types into the `SceneGraph`."""
struct SceneGraphNode
  scene::SceneGraph
  parent
  children::Vector
  offset::Vec3{Float32}
  rotation::Quaternion{Float32}
  scale::Vec3{Float32}
  local_to_parent::Mat4{Float32}
  local_to_global::Mat4{Float32}
  global_to_local::Mat4{Float32}
  dirty::Bool
end

function SceneGraphNode(
  scene,
  parent = nothing;
  offset = zeros(Vec3{FLoat32}),
  rotation = one(Quaternion{Float32}),
  scale = ones(Vec3{Float32}),
)
  SceneGraphNode(
    scene,
    parent,
    [],
    offset,
    rotation,
    scale,
    zeros(Mat4{Float32}),
    zeros(Mat4{Float32}),
    zeros(Mat4{Float32}),
    true,
  )
end

scene_node(ntt) = ntt.scene_node
scene_node(node::SceneGraphNode) = node
scene(ntt) = scene_node(ntt).scene
parentof(ntt) = scene_node(ntt).parent
childrenof(ntt) = scene_node(ntt).children

"""`rootof(ntt)` finds the entity in `ntt`'s ancestry without a parent, i.e. this tree's root node."""
function rootof(ntt)
  curr = ntt
  parent = parentof(curr)
  while parent !== nothing
    curr = parent
    parent = parentof(curr)
  end
  curr
end

"""Update the given `node` using its parent's local-to-global transformation matrix `parent_mat`."""
function ExtraFun.update!(node::SceneGraphNode, parent_mat::Mat4{Float32})
  if node.dirty
    node.dirty = false
    node.local_to_parent = translation_matrix(node.offset...) * rotation_matrix(node.rotation) * scale_matrix(node.scale...)
    node.local_to_global = node.local_to_parent * parent_mat
    node.global_to_local = inv(node.local_to_global)
  end
  node
end

translation_matrix(x, y, z) = @SMatrix([
  1 0 0 x ;
  0 1 0 y ;
  0 0 1 z ;
  0 0 0 1 ;
])
function rotation_matrix(quat::Quaternion)
  (; a, b, c, d) = quat
  @SMatrix [
    2(a^2 + b^2) - 1  2(b*c - a*d)      2(b*d + a*c)      0 ;
    2(b*c + a*d)      2(a^2 + c^2) - 1  2(c*d - a*b)      0 ;
    2(b*d - a*c)      2(c*d + a*b)      2(a^2 + d^2) - 1  0 ;
    0                 0                 0                 1 ;
  ]
end
scale_matrix(x, y, z) = @SMatrix([
  x 0 0 0 ;
  0 y 0 0 ;
  0 0 z 0 ;
  0 0 0 1 ;
])

end # module SceneGraphs
