require 'spec_helper'
require 'webmock/rspec'

module Rack::HTTPSpy
  describe Middleware do
    let(:spy)     { double 'spy' }
    let(:app)     { double "app" }
    let(:store)   { double "store" }
    let(:options) { {} }
    let(:middleware) { Middleware.new(app, options) }

    describe "#initialize" do
      it "initializes its attributes with the given app and options" do
        expect(middleware.app).to eq app
        expect(middleware.options).to eq options
      end

      context "WebMock" do
        before do
          WebMock.reset_callbacks
          stub_request(:any, "www.example.com")
          allow(middleware).to receive(:store).and_return(store)
        end

        it "hooks WebMock into all Net conections" do
          expect(WebMock).to receive(:disable_net_connect!).with(allow: /.*/)
          Middleware.new(app, options)
        end

        it "adds an after_request hook to WebMock to store every request" do
          expect(store).to receive(:store).with(request: an_instance_of(WebMock::RequestSignature)).at_least(:once)

          Net::HTTP.get(URI('http://www.example.com'))
        end
      end
    end

    describe "#call" do
      let(:env) { double "env" }

      it "calls #spy with env and itself" do
        expect(Spy).to receive(:spy).with(env: env, middleware: middleware)
        middleware.call(env)
      end
    end

    describe "#store" do
      context "when initialized without a :store option" do
        it "returns a RequestStore" do
          expect(middleware.store).to be_a RequestStore
        end
      end

      context "when initialized with a :store option" do
        before do
          options[:store] = store
        end

        it "returns optional :store" do
          expect(middleware.store).to eq store
        end
      end
    end

    describe "#reporter" do
      context "when initialized without a :reporter option" do
        it "returns Reporter" do
          expect(middleware.reporter).to eq Reporter
        end

        context "when initialized with a :reporter option" do
          let(:reporter) { double "reporter" }

          before do
            options[:reporter] = reporter
          end

          it "returns the optional reporter" do
            expect(middleware.reporter).to eq reporter
          end
        end
      end
    end

    %w(logger format log_level).each do |attr|
      describe "##{attr}" do
        context "when initialized with a :#{attr} option" do
          let(:dbl) { double attr }

          before do
            options[attr.to_sym] = dbl
          end

          it "returns the :#{attr} option" do
            expect(middleware.send(attr)).to eq dbl
          end
        end

        context "when not initialized with a :#{attr} option" do
          it "raises a KeyError" do
            pending "implement other log levels and formatters"
            expect { middleware.send(attr) }.to raise_error(KeyError)
          end
        end
      end
    end
  end
end
