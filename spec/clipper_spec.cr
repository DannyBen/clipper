require "./spec_helper"

describe Clipper do
  describe "#parse" do
    it "returns a hash of all actual and expected options" do
      subject = Clipper.new
      subject.flag "--one"
      subject.flag "--two", "-t"
      subject.flag "--name NAME", "-n NAME"
      subject.arg "command"

      options = subject.parse ["--one", "-n", "bob"]
      options.should eq({ "--one" => true, "--two" => false, "--name" => "bob", "command" => false})
    end
  end

  describe "#flag" do
    context "with long flag only" do
      subject = Clipper.new
      subject.flag "--bool"

      context "when it is not provided as input" do
        it "defaults it to false" do
          options = subject.parse
          options["--bool"].should be_false
        end
      end

      context "it is provided in as input" do
        it "sets it to true" do
          options = subject.parse ["--bool"]
          options["--bool"].should be_true
        end
      end
    end

    context "with both long and short flags" do
      subject = Clipper.new
      subject.flag "--bool", "-b"

      context "when it is not provided as input" do
        it "defaults it to false" do
          options = subject.parse
          options["--bool"].should be_false
        end
      end

      context "when it is provided in its long form" do
        it "sets it to true" do
          options = subject.parse ["--bool"]
          options["--bool"].should be_true
        end
      end

      context "when it is provided in its short form" do
        it "sets it to true" do
          options = subject.parse ["-b"]
          options["--bool"].should be_true
        end
      end
    end

    context "with a flag that requires a value" do
      subject = Clipper.new
      subject.flag "--port PORT", "-p PORT"

      context "when it is not provided as input" do
        it "defaults it to false" do
          options = subject.parse
          options["--port"].should be_false
        end
      end

      context "when it is provided in its long form" do
        it "sets its value" do
          options = subject.parse ["--port", "1234"]
          options["--port"].should eq "1234"
        end
      end

      context "when it is provided in its short form" do
        it "sets it to true" do
          options = subject.parse ["-p", "2345"]
          options["--port"].should eq "2345"
        end
      end
    end

    context "with a flag that requires a value but has a default" do
      subject = Clipper.new
      subject.flag "--port PORT", "-p PORT", default: "4000"

      context "when it is not provided as input" do
        it "sets it to the default value" do
          options = subject.parse
          options["--port"].should eq "4000"
        end
      end

      context "when it is provided as input" do
        it "sets its value" do
          options = subject.parse ["--port", "1234"]
          options["--port"].should eq "1234"
        end
      end

    end

  end

  describe "#arg" do
    subject = Clipper.new
    subject.arg "command"

    it "registers an expected option" do
      options = subject.parse
      options["command"].should be_false
    end

    context "when it is provided as input" do
      options = subject.parse ["download"]
      options["command"].should eq "download"      
    end
  end
end
