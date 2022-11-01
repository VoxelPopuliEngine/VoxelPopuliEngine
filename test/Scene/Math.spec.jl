module TestMath
using Test
using VoxelPopuliEngine.Scene.Math

@testset "Quaternion" begin
  @test Quaternion(32f0, 24, 42, 69.69) isa Quaternion{Float64}
  @test Quaternion{Float32}(24, 25, 42, 69) isa Quaternion{Float32}
  
  @test abs(Quaternion{Float32}(1, 2, 3, 4)) ≈ 5.477225575
  @test abs(normalize(Quaternion{Float32}(1, 2, 3, 4))) ≈ 1
  
  # TODO: arithmetics
end

end # module TestMath
