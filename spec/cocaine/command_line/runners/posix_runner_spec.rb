require 'spec_helper'

describe Cocaine::CommandLine::PosixRunner do
  if Cocaine::CommandLine::PosixRunner.supported?
    it_behaves_like 'a command that does not block'

    it 'runs the command given and captures the output' do
      output = subject.call("echo hello")
      expect(output).to have_output "hello\n"
    end

    it 'runs the command given and captures the error output' do
      output = subject.call("echo hello 1>&2")
      expect(output).to have_error_output "hello\n"
    end

    it 'modifies the environment and runs the command given' do
      output = subject.call("echo $yes", {"yes" => "no"})
      expect(output).to have_output "no\n"
    end

    it 'sets the exitstatus when a command completes' do
      subject.call("ruby -e 'exit 0'")
      $?.exitstatus.should == 0
      subject.call("ruby -e 'exit 5'")
      $?.exitstatus.should == 5
    end
  end
end
