require 'docker'

describe "Docker building" do

  RSpec.configure do |config|

    config.after :suite do
      $container.remove force: true
    end

  end

  context "when docker is supported" do

    it "have an URL" do
      expect(Docker.url).to_not be_nil
    end

    it "has version information" do
      expect(Docker.version).to_not be_nil
    end

    it "has a compatible version" do
      Gem::Version.new(Docker::version["Version"]) >= Gem::Version.new('1.3.0')
    end

    it "has a compatible api version" do
      Gem::Version.new(Docker::version["ApiVersion"]) >= Gem::Version.new('15')
    end

  end

  context "when building image" do

    it "have successfully built" do
      $image = Docker::Image.build_from_dir "."
      expect($image).to_not be_nil
    end

    it "exists" do
      expect(Docker::Image.exist? $image.id).to eql true
    end

  end

  context "when running new image" do

    it "creates the container" do
      $container = Docker::Container.create Image: $image.id
      expect($container).to_not be_nil
    end

    it "runs the container" do
      expect($container.start PublishAllPorts: true).to_not be_nil
    end

  end

end
