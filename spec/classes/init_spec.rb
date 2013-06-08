require 'spec_helper'

describe 'glacier' do
  it 'should include python-setuptools' do
    should contain_package('python-setuptools')
  end

  describe 'config template' do
    context 'default settings' do
      it 'should contain an AWS key' do
        should contain_file('/etc/glacier-cmd.conf').with_content(/AWSKEY/)
      end

      it 'should not contain an SBD key' do
        should_not contain_file('/etc/glacier-cmd.conf').with_content(/SDBKEY/)
      end
    end

    context 'set a SDB key' do
      let(:params) { { :sdb_access_key => 'FOOBARSDBKEY' } }

      it 'should contain an SDB key' do
        should contain_file('/etc/glacier-cmd.conf').with_content(/SDBKEY/)
      end
    end
  end
end
