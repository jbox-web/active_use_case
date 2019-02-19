require 'spec_helper'

describe ActiveUseCase::UseCaseBuilder do

  def build_use_case(name = :resync!, namespace = nil, prefix = nil)
    ActiveUseCase::UseCaseBuilder.new(name, namespace, prefix)
  end

  subject { build_use_case }

  describe '#method' do
    it 'should return the method associated with the UseCase' do
      expect(subject.method).to eq :resync!
    end
  end

  describe '#name' do
    it 'should return the UseCase name' do
      expect(subject.name).to eq 'resync'
    end
  end

  describe '#namespace' do
    context 'with no namespace' do
      it 'should return the UseCase namespace' do
        expect(subject.namespace).to be nil
      end
    end
    context 'with namespace' do
      it 'should return the UseCase namespace' do
        subject = build_use_case(nil, 'Comments')
        expect(subject.namespace).to eq 'Comments'
      end
    end
  end

  describe '#prefix' do
    context 'with no prefix' do
      it "should return the UseCase namespace's prefix" do
        expect(subject.prefix).to be nil
      end
    end
    context 'with prefix' do
      it "should return the UseCase namespace's prefix" do
        subject = build_use_case(nil, nil, 'Files')
        expect(subject.prefix).to eq 'Files'
      end
    end
  end

  describe '#klass_name' do
    it 'should return the klass name of the UseCase' do
      expect(subject.klass_name).to eq 'Resync'
    end
  end

  describe '#klass_path' do
    context 'with no prefix' do
      it 'should return the klass path of the UseCase' do
        expect(subject.klass_path).to eq 'Resync'
      end
    end

    context 'with prefix' do
      it 'should return the klass path of the UseCase' do
        subject = build_use_case(:resync!, 'Files')
        expect(subject.klass_path).to eq 'Files::Resync'
      end
    end
  end


  describe '#klass' do
    context 'when UseCase klass exists' do
      it 'should return the UseCase klass name' do
        subject = build_use_case(:send_email!, 'Comments')
        expect(subject.klass_path).to eq 'Comments::SendEmail'
        expect(subject.klass).to eq Comments::SendEmail
      end
    end

    context 'when UseCase klass dont exists' do
      it 'should return nil' do
        expect(subject.klass).to be nil
      end
    end
  end


  describe '#exists?' do
    context 'when UseCase klass exists' do
      it 'should return true' do
        subject = build_use_case(:send_email!, 'Comments')
        expect(subject.klass_path).to eq 'Comments::SendEmail'
        expect(subject.klass).to eq Comments::SendEmail
        expect(subject.exists?).to be true
      end
    end

    context 'when UseCase klass dont exists' do
      it 'should return false' do
        expect(subject.exists?).to be false
      end
    end
  end


  describe '#to_object' do
    context 'when UseCase klass exists' do
      it 'should return the a new instance of UseCase' do
        subject = build_use_case(:send_email!, 'Comments')
        expect(subject.klass_path).to eq 'Comments::SendEmail'
        expect(subject.klass).to eq Comments::SendEmail
        expect(subject.exists?).to be true
        object = Comment.new
        expect(subject.to_object(object)).to be_a Comments::SendEmail
        expect(subject.to_object(object).object).to eq object
      end
    end

    context 'when UseCase klass dont exists' do
      it 'should raise an error' do
        object = Comment.new
        expect{ subject.to_object(object) }.to raise_error(ActiveUseCase::Error::UseCaseClassNotFoundError)
      end
    end
  end

end
