require 'spec_helper'

describe Jeapie do

  before(:each) do
    Jeapie.clear
    Jeapie.configure do |c|
      c.user='qwqwqwqwqwqwqwqwqwqwqwqwqwqwqwqw'
      c.token='asasasasasasasasasasasasasasasas'
    end
    FakeWeb.clean_registry
  end
  let(:api_url){Jeapie::API_URL}
  let(:api_ok_answer){'{"success":true,"message":"Message was sent successfully"}'}
  let(:api_fail_answer){'{"success":false,"errors":{"device":["Some error"]}}'}

  describe '#configure' do
    Jeapie.keys.each do |key|
      it "#{key} should be configured via .configure" do
        r = 'qwerty'
        Jeapie.configure do |c|
          c.instance_variable_set "@#{key}", r
        end
        Jeapie.send(key).should eq r
      end
    end
  end

  describe '#parameters' do
    it 'should return all params' do
      p={token:'1', user:'2', message:'3', title:'4', device:'5', priority:'6'}
      p.each do |k,v|
        Jeapie.send "#{k}=", v
      end
      Jeapie.parameters.should == p
    end
  end

  describe '#notify' do
    subject{ Jeapie.notify(params) }


    context 'when all params OK' do
      let(:params){ {message:'Text'} }
      context 'and when server return OK' do
        before(:each){FakeWeb.register_uri(:post, api_url, :body => api_ok_answer) }
        it 'should return "true"' do
          subject.should be_true
          FakeWeb.should have_requested(:post, api_url)
        end
      end
      context 'and when server return error' do
        before(:each){FakeWeb.register_uri(:post, api_url, :body => api_fail_answer) }
        it 'should return "false" and "errors" must contain info about error' do
          subject.should be_false
          Jeapie.errors.should match /code:/
          FakeWeb.should have_requested(:post, api_url)
        end
      end

    end

    context 'when "message" missing' do
      let(:params){ {message:''} }
      it 'should return "false" and "errors" must contain info about error' do
        subject.should be_false
        Jeapie.errors.should match /Params not valid:/
        FakeWeb.should_not have_requested(:post, api_url)
      end
    end

    context 'when message too long' do
      let(:params){ {message:'q'*2001} }
      it 'should return "false" and "errors" must contain "Message too long"' do
        subject.should be_false
        Jeapie.errors.should match /Message too long/
      end
    end
  end


end
