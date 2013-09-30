class MyClass
  def my_method
    @hash = {2 => "foo", 3 => "bar", 5 => "baz"}
    @string = "quux"
  end
end

require File.join(__dir__, "..", "lib", "allocation_stats")

stats = AllocationStats.new { MyClass.new.my_method }
puts stats.allocations(alias_paths: true).group_by(:sourcefile, :sourceline, :class).to_text
