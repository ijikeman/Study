require 'spec_helper'
require 'logging'

describe "Logging::logger" do
# describe "Logging::logger_init_and_set_params" do
  context "loggerにlevelとoutputを渡すとその値になる" do
    subject { Logging::logger('FATAL', STDOUT).level}
        it { should == Logger::FATAL }
  end

  # it "logger引数を渡さない場合はlevel=ERROR, output=STDERR" do
    # expect(Logging::logger.level).to eq Logger::ERROR
    # expect(Logging::logger.dev).to eq STDERR
  # end

  context "Logger self.set_level" do
    subject { Logging.send(:set_level, 'INFO') }
    it { should == Logger::INFO }
  end

  context "Logger self.init" do
    subject { Logging.send(:init, 'INFO', STDOUT).level }
    it { should == Logger::INFO }
  end
end

