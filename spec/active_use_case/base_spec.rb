require 'rails_helper'

describe ActiveUseCase::Base do

  def build_use_case_object
    build(:comment).send_email!(Email.new)
  end

  subject { build_use_case_object }

  describe '#to_method' do
    it 'should return the method associated with the UseCase' do
      expect(subject.to_method).to eq 'send_email!'
    end
  end


  describe '#success?' do
    it 'should return true if UseCase has no errors' do
      expect(subject.success?).to be true
    end
  end


  describe '#errors' do
    it 'should return an empty array when no errors' do
      expect(subject.errors).to eq []
    end

    it 'should return an array when of errors' do
      subject.send(:error_message, 'foo')
      subject.send(:error_message, 'bar')
      expect(subject.errors).to eq ['foo', 'bar']
    end

    it 'should return an array when of unique errors' do
      subject.send(:error_message, 'foo')
      subject.send(:error_message, 'foo')
      expect(subject.errors).to eq ['foo']
    end
  end


  describe '#message_on_start' do
    it 'should return a message to display when UseCase is called' do
      expect(subject.message_on_start).to eq 'Send mail start'
    end
  end


  describe '#message_on_success' do
    it 'should return a message to display when UseCase is success' do
      expect(subject.message_on_success).to eq 'Send mail success'
    end
  end


  describe '#message_on_errors' do
    it 'should return a message to display when UseCase has failed' do
      expect(subject.message_on_errors).to eq 'Send mail failed'
    end
  end


  describe '#message_on_nil_object' do
    it 'should return a message to display when UseCase object is nil' do
      expect(subject.message_on_nil_object).to eq 'Send mail object is nil'
    end
  end

end
