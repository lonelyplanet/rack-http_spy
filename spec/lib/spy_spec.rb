require 'spec_helper'

module Rack::HTTPSpy
  describe Spy do
    let(:env)        { double "env" }
    let(:app)        { double "app" }
    let(:request)    { double "request" }
    let(:response)   { double "response" }
    let(:store)      { double "store", :clear! => true }
    let(:middleware) { double "middleware", store: store }
    let(:spy)        { Spy.new(middleware: middleware, env: env) }

    describe ".spy" do
      let(:result) { double "result" }

      before do
        allow_any_instance_of(Spy).to receive(:spy).and_return(result)
      end

      it "initializes a new Spy with the args" do
        expect(Spy).to receive(:new).with(middleware: middleware, env: env).and_return(spy)
        Spy.spy(middleware: middleware, env: env)
      end

      it "returns the result of #spy on the new Spy" do
        Spy.spy(middleware: middleware, env: env)
        expect(Spy.spy(middleware: middleware, env: env)).to eq result
      end
    end

    describe "#initialize" do
      it "clears the store" do
        expect(store).to receive(:clear!)
        spy
      end

      context "when :env and :middleware options are passed" do
        it "sets the :env and :middleware attributes" do
          expect(spy.env).to eq env
          expect(spy.middleware).to eq middleware
        end
      end

      context "when either :env or :middleware options are no passed" do
        it "raises KeyError" do
          expect { Spy.new }.to raise_error(KeyError)
        end
      end
    end

    describe "#request" do
      it "returns Rack::Request built from the env" do
        expect(Rack::Request).to receive(:new).with(env).and_return(request)
        expect(spy.request).to eq request
      end
    end

    describe "#params" do
      let(:params) { double "params" }

      before do
        allow(spy).to receive(:request).and_return(request)
      end

      it "returns the params of the request" do
        expect(request).to receive(:params).and_return(params)
        expect(spy.params).to eq(params)
      end
    end

    describe "#spy_params" do
      before do
        allow(spy).to receive(:params).and_return({ "foo" => "bar", "_spy" => "expected" })
      end

      it "returns all the params nested under the key '_spy'" do
        expect(spy.spy_params).to eq "expected"
      end
    end

    %w(log_level format).each do |mth|
      describe "##{mth}" do
        let(:dbl) { double mth }

        context "spy_params has :#{mth} key" do
          before do
            allow(spy).to receive(:spy_params).and_return({ mth => dbl })
          end

          it "returns the value of the key" do
            expect(spy.send(mth)).to eq dbl
          end
        end

        context "when spy_params does not have :#{mth} key" do
          before do
            allow(spy).to receive(:spy_params).and_return({})
          end

          it "returns default_#{mth}" do
            expect(spy).to receive("default_#{mth}").and_return dbl
            expect(spy.send(mth)).to eq dbl
          end
        end
      end
    end

    describe "#enabled?" do
      context "when there spy params present" do
        before do
          allow(spy).to receive(:spy_params).and_return("present")
        end

        it "returns true" do
          expect(spy).to be_enabled
        end
      end

      context "when there are no spy params" do
        before do
          allow(spy).to receive(:spy_params).and_return(nil)
        end

        it "returns true" do
          expect(spy).not_to be_enabled
        end
      end
    end

    describe "#store" do
      it "returns the middleware's store" do
        expect(middleware).to receive(:store).and_return(store)
        expect(spy.store).to eq store
      end
    end

    %w(app reporter logger).each do |mth|
      describe "##{mth}" do
        let(:dbl) { double mth }

        it "returns the middleware's #{mth}" do
          expect(middleware).to receive(mth).and_return(dbl)
          expect(spy.send(mth)).to eq dbl
        end
      end
    end

    describe "#original_response" do
      before do
        allow(spy).to receive(:app).and_return(app)
      end

      it "returns the response from the app" do
        expect(app).to receive(:call).with(env).and_return(response)
        expect(spy.original_response).to eq response
      end
    end

    describe "#report" do
      let(:format)    { double "format" }
      let(:log_level) { double "log_level" }
      let(:report)   { double "report" }
      let(:reporter) { double "reporter" }

      before do
        { reporter: reporter, format: format, log_level: log_level, store: store }.each do |m, v|
          allow(spy).to receive(m).and_return(v)
        end
      end

      it "returns a reporter.report for the given store, format, and log_level" do
        expect(reporter).to receive(:report).with(hash_including(store: store, format: format, log_level: log_level)).and_return(report)
        expect(spy.report).to eq report
      end
    end

    describe "#spy" do
      before do
        allow(spy).to receive(:original_response).and_return(response)
      end

      context "when not enabled?" do
        before do
          allow(spy).to receive(:enabled?).and_return(false)
        end

        it "returns the original response" do
          expect(spy.spy).to eq response
        end
      end

      context "when enabled?" do
        let(:report) { double "report" }
        let(:logger) { double "logger" }

        before do
          { store: store, report: report, :enabled? => true }.each do |m, v|
            allow(spy).to receive(m).and_return(v)
          end
          allow(store).to receive(:clear!)
          allow(logger).to receive(:info)
        end

        context "when a logger is set" do
          before do
            allow(spy).to receive(:logger).and_return(logger)
          end

          it "logs a stringified report to the logger" do
            expect(logger).to receive(:info).with(report.to_s)
            spy.spy
          end

          it "returns the original response" do
            expect(spy.spy).to eq response
          end
        end

        context "when a logger is not set" do
          let(:report_response) { double "report response" }

          before do
            allow(spy).to receive(:logger).and_return(nil)
          end

          it "returns the report as a response" do
            expect(report).to receive(:to_response).and_return(report_response)
            expect(spy.spy).to eq report_response
          end
        end
      end
    end
  end
end
