require 'spec_helper'

describe GitlabRuby::QueryChain do
  let(:query_chain) { GitlabRuby::QueryChain.new }
  methods_list = []
  CSV.foreach("lib/gitlab_ruby/routes_table_no_verb.csv") do |row|
    path = Mustermann.new(row.first)
    stacks = path.to_templates.first.split(/(\.|\/)/)
    stacks = stacks.map { |s| s if s.size > 1 }.compact
    stacks.each_with_index do |s, index|
      if index == stacks.size - 1
        key = s.match(/{(.+)}/)[1]
      elsif s.match(/{.+}/)
        key = s.match(/{(.+)}/)[1]
      else
        key = s
      end
      methods_list << key
    end
  end
  methods_list.uniq!

  describe 'passing NO parameter' do
    methods_list.each do |method|
      it method.to_s do
        expect(query_chain).to respond_to(method)
      end
    end
  end

  describe 'passing ONE parameter' do
    methods_list.each do |method|
      it method.to_s do
        expect(query_chain).to respond_to(method).with(1)
      end
    end
  end

  describe 'passing MORE THAN ONE parameter' do
    methods_list.each do |method|
      it method.to_s do
        expect { query_chain.send(method, 1, 2) }.to \
        raise_error GitlabRuby::Errors::QueryChainArgumentError
      end
    end
  end
end
