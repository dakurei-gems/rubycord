require "securerandom"
require "rubycord/webhooks"

describe Rubycord::Webhooks do
  describe Rubycord::Webhooks::Builder do
    it "should be able to add embeds" do
      builder = Rubycord::Webhooks::Builder.new

      embed = builder.add_embed do |e|
        e.title = "a"
        e.image = Rubycord::Webhooks::EmbedImage.new(url: "https://example.com/image.png")
      end

      expect(builder.embeds.length).to eq 1
      expect(builder.embeds.first).to eq embed
    end
  end

  describe Rubycord::Webhooks::Embed do
    it "should be able to have fields added" do
      embed = Rubycord::Webhooks::Embed.new

      embed.add_field(name: "a", value: "b", inline: true)

      expect(embed.fields.length).to eq 1
    end

    describe "#colour=" do
      it "should accept colours in decimal format" do
        embed = Rubycord::Webhooks::Embed.new
        colour = 1234

        embed.colour = colour
        expect(embed.colour).to eq colour
      end

      it "should raise if the colour value is too high" do
        embed = Rubycord::Webhooks::Embed.new
        colour = 100_000_000

        expect { embed.colour = colour }.to raise_error(ArgumentError)
      end

      it "should accept colours in hex format" do
        embed = Rubycord::Webhooks::Embed.new
        colour = "162a3f"

        embed.colour = colour
        expect(embed.colour).to eq 1_452_607
      end

      it "should accept colours in hex format with a # in front" do
        embed = Rubycord::Webhooks::Embed.new
        colour = "#162a3f"

        embed.colour = colour
        expect(embed.colour).to eq 1_452_607
      end

      it "should accept colours as a RGB tuple" do
        embed = Rubycord::Webhooks::Embed.new
        colour = [22, 42, 63]

        embed.colour = colour
        expect(embed.colour).to eq 1_452_607
      end

      it "should raise if a RGB tuple is of the wrong size" do
        embed = Rubycord::Webhooks::Embed.new

        expect { embed.colour = [0, 1] }.to raise_error(ArgumentError)
        expect { embed.colour = [0, 1, 2, 3] }.to raise_error(ArgumentError)
      end

      it "should raise if a RGB tuple results in a too large value" do
        embed = Rubycord::Webhooks::Embed.new

        expect { embed.colour = [2000, 1, 2] }.to raise_error(ArgumentError)
      end
    end
  end

  describe Rubycord::Webhooks::Client do
    let(:id) { SecureRandom.bytes(8) }
    let(:token) { SecureRandom.bytes(24) }
    let(:provided_url) { instance_double(String) }

    subject { described_class.new(url: provided_url) }

    describe "#initialize" do
      it "generates a url from id and token" do
        client = described_class.new(id: id, token: token)
        url = client.instance_variable_get(:@url)

        expect(url).to eq "https://discord.com/api/v9/webhooks/#{id}/#{token}"
      end

      it "takes a provided url" do
        client = described_class.new(url: provided_url)
        url = client.instance_variable_get(:@url)

        expect(url).to be provided_url
      end
    end

    describe "#avatarise" do
      let(:data) { SecureRandom.bytes(24) }

      it "makes no changes if the argument does not respond to read" do
        expect(subject.__send__(:avatarise, data)).to be data
      end

      it "returns multipart data if the argument responds to read" do
        encoded = subject.__send__(:avatarise, StringIO.new(data))
        expect(encoded).to eq "data:image/jpg;base64,#{Base64.strict_encode64(data)}"
      end
    end
  end
end
