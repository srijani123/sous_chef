require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SousChef::Resource::Directory do
  before do
    @directory = resource("bin") do
    end
    @directory.to_script # evaluate the block
  end

  it "has a name" do
    @directory.name.should == "bin"
  end

  it "has a path equal to the name when no explicit path is given" do
    @directory.path.should == "bin"
  end

  it "has a path as set when an explicit path is given" do
    @directory = resource("bin") do
      path "/home/user/bin"
    end
    @directory.to_script # evaluate the block
    @directory.path.should == "/home/user/bin"
  end

  it "creates the directory" do
    @directory.to_script.should == %{mkdir -p bin}
  end

  it "allows deleting the directory" do
    directory = resource("bin") do
      action :delete
    end
    directory.to_script.should == %{rmdir bin}
  end

  it "raises an argument error on bad action" do
    lambda {
      resource("bin") { action :email }.setup
    }.should raise_error(ArgumentError)
  end

  it "sets the mode of the directory" do
    @directory = resource("bin") do
      mode 0600
    end

    @directory.to_script.should == %q{
mkdir -p bin
chmod 0600 bin
    }.strip
  end

  it "force deletes the directory" do
    directory = resource("bin") do
      action :delete
      force true
    end
    directory.to_script.should == %{rm -rf bin}
  end
end
