require "rubycord/voice/sodium"

describe Rubycord::Voice::SecretBox do
  def rand_bytes(size)
    bytes = Array.new(size) { rand(256) }
    bytes.pack("C*")
  end

  it "encrypts round trip" do
    key = rand_bytes(Rubycord::Voice::SecretBox::KEY_LENGTH)
    nonce = rand_bytes(Rubycord::Voice::SecretBox::NONCE_BYTES)
    message = rand_bytes(20)

    secret_box = Rubycord::Voice::SecretBox.new(key)
    ct = secret_box.box(nonce, message)
    pt = secret_box.open(nonce, ct)
    expect(pt).to eq message
  end

  it "raises on invalid key length" do
    key = rand_bytes(Rubycord::Voice::SecretBox::KEY_LENGTH - 1)
    expect { Rubycord::Voice::SecretBox.new(key) }.to raise_error(Rubycord::Voice::SecretBox::LengthError)
  end

  describe "#box" do
    it "raises on invalid nonce length" do
      key = rand_bytes(Rubycord::Voice::SecretBox::KEY_LENGTH)
      nonce = rand_bytes(Rubycord::Voice::SecretBox::NONCE_BYTES - 1)
      expect { Rubycord::Voice::SecretBox.new(key).box(nonce, "") }.to raise_error(Rubycord::Voice::SecretBox::LengthError)
    end
  end

  describe "#open" do
    it "raises on invalid nonce length" do
      key = rand_bytes(Rubycord::Voice::SecretBox::KEY_LENGTH)
      nonce = rand_bytes(Rubycord::Voice::SecretBox::NONCE_BYTES - 1)
      expect { Rubycord::Voice::SecretBox.new(key).open(nonce, "") }.to raise_error(Rubycord::Voice::SecretBox::LengthError)
    end
  end
end
