require 'rails_helper'

describe Comment do
  subject { build(:comment) }

  ## Global validation
  it { should be_valid }


  describe '.add_use_cases' do
    it 'should declare a new method called send_email!' do
      expect(subject).to respond_to(:send_email!).with(1).arguments
    end

    it 'should declare a new method called build_send_email_use_case' do
      expect(subject).to respond_to(:build_send_email_use_case).with(0).arguments
    end

    it 'should declare a new method called resync!' do
      expect(subject).to respond_to(:resync!).with(1).arguments
    end

    it 'should declare a new method called build_resync_use_case' do
      expect(subject).to respond_to(:build_resync_use_case).with(0).arguments
    end

    context 'with prefix option' do
      it 'should return a prefixed UseCase klass' do
        use_case = Comment.active_use_cases[:resync!]
        expect(use_case).to be_a ActiveUseCase::UseCase
        expect(use_case.method).to eq :resync!
        expect(use_case.name).to eq 'resync'
        expect(use_case.parent_klass).to eq 'Comments'
        expect(use_case.prefix).to eq '::Files'
        expect(use_case.klass_name).to eq 'Resync'
        expect(use_case.klass_path).to eq 'Comments::Files::Resync'
        expect(use_case.exists?).to be false
      end
    end
  end


  describe '.active_use_cases' do
    it 'should return a hash of UseCases' do
      expect(Comment.active_use_cases).to be_a Hash
      expect(Comment.active_use_cases[:send_email!]).to be_a ActiveUseCase::UseCase
      expect(Comment.active_use_cases[:generate_pdf!]).to be_a ActiveUseCase::UseCase
      expect(Comment.active_use_cases[:resync!]).to be_a ActiveUseCase::UseCase
    end
  end


  describe '.find_active_use_case' do
    context "when UseCase is not registered" do
      it 'should raise an error' do
        expect { Comment.find_active_use_case(:foo!) }.to raise_error(ActiveUseCase::Errors::UseCaseNotDefinedError)
      end
    end

    context "when UseCase klass don't exist" do
      it 'should raise an error' do
        expect { Comment.find_active_use_case(:resync!) }.to raise_error(ActiveUseCase::Errors::UseCaseClassNotFoundError)
      end
    end

    context 'when UseCase klass exist' do
      it 'should accept strings and symbols and return UseCase' do
        expect(Comment.find_active_use_case('send_email!')).to be_a ActiveUseCase::UseCase
        expect(Comment.find_active_use_case(:send_email!)).to be_a ActiveUseCase::UseCase
      end

      it 'should accept banged and not banged methods and return UseCase' do
        expect(Comment.find_active_use_case(:send_email)).to be_a ActiveUseCase::UseCase
        expect(Comment.find_active_use_case(:send_email!)).to be_a ActiveUseCase::UseCase
      end
    end
  end


  describe '#find_active_use_case' do
    context "when UseCase is not registered" do
      it 'should raise an error' do
        expect { subject.find_active_use_case(:foo!) }.to raise_error(ActiveUseCase::Errors::UseCaseNotDefinedError)
      end
    end

    context "when UseCase klass don't exist" do
      it 'should raise an error' do
        expect { subject.find_active_use_case(:resync!) }.to raise_error(ActiveUseCase::Errors::UseCaseClassNotFoundError)
      end
    end

    context 'when UseCase klass exist' do
      it 'should accept strings and symbols and return UseCase' do
        expect(subject.find_active_use_case('send_email!')).to be_a Comments::SendEmail
        expect(subject.find_active_use_case(:send_email!)).to be_a Comments::SendEmail
      end

      it 'should accept banged and not banged methods and return UseCase' do
        expect(subject.find_active_use_case(:send_email)).to be_a Comments::SendEmail
        expect(subject.find_active_use_case(:send_email!)).to be_a Comments::SendEmail
      end
    end
  end


  describe '#build_send_email_use_case' do
    it 'should return a new use case objec ready to be run' do
      use_case = subject.build_send_email_use_case
      expect(use_case).to be_a ActiveUseCase::UseCase
      expect(use_case.method).to eq :send_email!
      expect(use_case.name).to eq 'send_email'
      expect(use_case.parent_klass).to eq 'Comments'
      expect(use_case.prefix).to eq ''
      expect(use_case.klass_name).to eq 'SendEmail'
      expect(use_case.klass_path).to eq 'Comments::SendEmail'
      expect(use_case.exists?).to be true
    end
  end


  describe '#use_case_method' do

    context "when UseCase don't exist" do
      let(:email) { Email.new }
      describe '#resync!' do
        it 'should raise an error on call' do
          expect { subject.resync!(email) }.to raise_error(ActiveUseCase::Errors::UseCaseClassNotFoundError)
        end
      end
    end

    context "when UseCase exist" do
      let(:email) { Email.new }

      describe '#send_email!' do
        context 'with 1 arg' do
          it 'should return a UseCase object' do
            expect_any_instance_of(Comments::SendEmail).to receive(:execute).with(email)
            use_case = subject.send_email!(email)
            expect(use_case).to be_a Comments::SendEmail
            expect(use_case.use_case).to eq 'send_email'
            expect(use_case.to_method).to eq 'send_email!'
            expect(use_case.object).to eq subject
          end
        end

        context 'with 2 args' do
          it 'should return a UseCase object' do
            expect_any_instance_of(Comments::SendSms).to receive(:execute).with(email, email)
            use_case = subject.send_sms!(email, email)
            expect(use_case).to be_a Comments::SendSms
            expect(use_case.use_case).to eq 'send_sms'
            expect(use_case.to_method).to eq 'send_sms!'
            expect(use_case.object).to eq subject
          end
        end

        context 'with 2 args and a hash of options' do
          it 'should return a UseCase object' do
            expect_any_instance_of(Comments::SendSms).to receive(:execute).with(email, email, { force: true })
            use_case = subject.send_sms!(email, email, force: true)
            expect(use_case).to be_a Comments::SendSms
            expect(use_case.use_case).to eq 'send_sms'
            expect(use_case.to_method).to eq 'send_sms!'
            expect(use_case.object).to eq subject
          end
        end

        context 'with 1 arg and a block' do
          it 'should yield the block and return a UseCase object' do
            use_case = subject.send_email!(email) do |arg|
              expect(arg).to eq(email)
            end
            expect(use_case).to be_a Comments::SendEmail
            expect(use_case.use_case).to eq 'send_email'
            expect(use_case.to_method).to eq 'send_email!'
            expect(use_case.object).to eq subject
          end
        end
      end
    end

  end
end
