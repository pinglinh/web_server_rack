require "open-uri"

describe "Server" do

  def read_body
    body_content = ""
    open("http://localhost:8080/") { |f|
      f.each_line { |line| body_content << line }
    }
    body_content
  rescue Errno::ECONNREFUSED
  end

  after do
    Process.kill(15, @pid)
    Process.wait @pid
  end

  it "renders the index" do

    @pid = spawn("bin/my_rack_app")

    until body_content = read_body
      puts "I'm going to try again..."
      sleep 1
    end

    expect(body_content).to include("Welcome")

  end
end
