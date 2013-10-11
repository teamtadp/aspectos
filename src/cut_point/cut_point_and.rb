class CutPointAnd < AbstractJoinPoint
  # Cut point que implementa el and entre joinpoints y cutpoints tambien.
  def initialize(join_points)
    @cp_join_points = join_points
  end

  def applies(a_method,a_class)
    @cp_join_points.all? do |join_point|
      join_point.applies(a_method, a_class)
    end
  end

end