require 'spec_helper'
require 'tmpdir'
require './dovecot'


describe 'Dovecot' do
  let(:fixture_path) {File.expand_path(File.join('..', '..', 'spec', 'fixtures'), __FILE__) }
  let(:domain1) { 'example.com' }
  let(:domain2) { 'example.net' }
  let(:domain3) { 'example.biz' }
  let(:user1) { ['example.com', 'user1'] }
  let(:user2) { ['example.com', 'user2'] }
  let(:user3) { ['example.net', 'user3'] }
  before {
    @tmp_path = Dir.mktmpdir
    @domain1_path = File.join(@tmp_path, domain1)
    @domain1_domain_sieve_path = File.join(@tmp_path, domain1, '.domain_sieve')
    @domain2_path = File.join(@tmp_path, domain2)
    @domain3_path = File.join(@tmp_path, domain3)
    @user1_path = File.join(@tmp_path, user1)
    @user2_path = File.join(@tmp_path, user2)
    @user3_path = File.join(@tmp_path, user3)
    FileUtils.mkdir_p(@domain1_path)
    FileUtils.mkdir_p(@domain1_domain_sieve_path)
    FileUtils.mkdir_p(@domain2_path)
    FileUtils.mkdir_p(@domain3_path)
    FileUtils.mkdir_p(@user1_path)
    FileUtils.mkdir_p(@user2_path)
    FileUtils.mkdir_p(@user3_path)
    FileUtils.cp(File.join(fixture_path, 'ZENLOGIC-1261', 'dovecot.sieve.example.com.user1'), File.join(@user1_path, '.dovecot.sieve'))
    FileUtils.cp(File.join(fixture_path, 'ZENLOGIC-1261', 'dovecot.sieve.example.com.user2'), File.join(@user2_path, '.dovecot.sieve'))
    FileUtils.cp(File.join(fixture_path, 'ZENLOGIC-1261', 'dovecot.sieve.example.net.user3'), File.join(@user3_path, '.dovecot.sieve'))
    stub_const("Dovecot::MAILSPOOLS_PATH", @tmp_path)
  }
  after{
    FileUtils.rm_rf(@tmp_path)
  }

  describe 'Dovecot::Vmail' do
    describe '#directories' do
      it "return 2 users when call directories method in domain1" do
        ret = Dovecot::Vmail.send(:directories, @domain1_path)
        expect(ret.length).to eq 2
        expect(ret).to include("user1")
        expect(ret).to include("user2")
      end

      it "return s when call directories method in user1" do
        ret = Dovecot::Vmail.send(:directories, @user1_path)
        expect(ret.length).to eq 0
      end
    end

    describe '#vdomians' do
      it "return vdomains when call vdomains method" do
        vdomains = Dovecot::Vmail.vdomains
        expect(vdomains.length).to eq 3
        expect(vdomains).to include(domain1)
        expect(vdomains).to include(domain2)
        expect(vdomains).to include(domain3)
      end

      it "raise NameError when call vdomain method in not exists MAILSPOOLS_PATH" do
        stub_const("Dovecot::Vmail::MAILSPOOLS_PATH", "/test")
        expect(Dovecot::Vmail.vdomains).to be_nil
      end
    end

    describe '#vaccounts' do
      it "return vaccounts when call vaccounts method in example.com" do
        vaccounts = Dovecot::Vmail.vaccounts(domain1)
        expect(vaccounts.length).to eq 2
        expect(vaccounts).to include("user1")
        expect(vaccounts).to include("user2")
      end

      it "raise NameError when call vaccounts method in not exists domain" do
        expect(Dovecot::Vmail.vaccounts(domain3)).to eq []
      end
    end
  end

  describe 'Dovecot::Sieve' do
    describe '#read' do
      before {
        @user1_sieve = Dovecot::Sieve.new(domain1, "user1")
      }
      it "return vaccounts when call vaccounts method in " do
        expect(@user1_sieve.read).not_to eq FALSE
      end
    end
  end
end
