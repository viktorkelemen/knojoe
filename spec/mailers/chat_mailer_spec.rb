require "spec_helper"

describe ChatMailer do
  describe "send_conversation" do
    let(:mail) { ChatMailer.send_conversation }

    it "renders the headers" do
      mail.subject.should eq("Send conversation")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
