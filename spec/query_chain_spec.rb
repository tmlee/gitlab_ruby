require 'spec_helper'

describe GitlabRuby::QueryChain do
  let(:query_chain) { GitlabRuby::QueryChain.new }
  methods_list = []
  CSV.foreach('lib/gitlab_ruby/routes_table_no_verb.csv') do |row|
    query_stacks = GitlabRuby::Helpers::QueryChain.to_query_stacks(row)
    query_stacks.each_with_index do |key|
      key = key.match(/{(.+)}/)[1] if key.match(/{.+}/)
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
          raise_error GitlabRuby::QueryChainArgumentError
      end
    end
  end
end
