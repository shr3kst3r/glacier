require 'spec_helper'

describe 'glacier' do
  it 'should include python-setuptools' do
    should contain_package('python-setuptools')
  end
end
