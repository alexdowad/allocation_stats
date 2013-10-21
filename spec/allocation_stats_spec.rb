# Copyright 2013 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0, found in the LICENSE file.

require_relative File.join("spec_helper")

describe AllocationStats do
  it "should trace everything if TRACE_PROCESS_ALLOCATIONS" do
    IO.popen({"TRACE_PROCESS_ALLOCATIONS" => "1"}, "ruby -r ./lib/allocation_stats -e 'puts 0'") do |io|
      out = io.read
      out.should match("Object Allocation Report")
    end
  end

  it "should only track new objects" do
    existing_array = [1,2,3,4,5]

    stats = AllocationStats.new.trace do
      new_array = [1,2,3,4,5]
    end

    stats.new_allocations.class.should be Array
    stats.new_allocations.size.should == 1
  end

  it "should only track new objects, non-block mode" do
    existing_array = [1,2,3,4,5]

    stats = AllocationStats.new.trace
    new_array = [1,2,3,4,5]
    stats.stop

    stats.new_allocations.class.should be Array
    stats.new_allocations.size.should == 1
  end

  it "should only track new objects; Hash String count twice :(" do
    existing_array = [1,2,3,4,5]

    stats = AllocationStats.new.trace do
      new_hash = {"foo" => "bar", "baz" => "quux"}
    end

    stats.new_allocations.size.should == 7
  end

  it "should only track new objects" do
    existing_array = [1,2,3,4,5]

    stats = AllocationStats.new.trace do
      new_object = Object.new
      new_array  = [4]
      new_string = "yarn"
    end

    stats.new_allocations.class.should be Array
    stats.new_allocations.size.should == 3
  end
end
