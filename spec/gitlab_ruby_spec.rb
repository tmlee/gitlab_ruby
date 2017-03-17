require 'spec_helper'

describe GitlabRuby do
  let(:client) { GitlabRuby::Client.new(token: TEST_API_KEY, version: "v4") }

  before do
    GitlabRuby::Client.debug = true # Toggle DEBUG for additional logs
  end

  it 'has a version number' do
    expect(GitlabRuby::VERSION).not_to be nil
  end

  it 'get single project', vcr: true do
    project = client.get.projects.id(2868483).execute
    expect(project.name).to eq 'rn.absent'
  end

  it 'restarts a new chain of queries' do
    project1 = client.get.projects.id(2868483).issues
    project2 = client.get.projects.id(2868483)
    expect(project1.urlstring).to eq 'projects/2868483/issues/'
    expect(project2.urlstring).to eq 'projects/2868483/'
  end

  describe 'Errors' do
    it 'raises bad request error', vcr: true do
      expect{ client.post.projects.execute }.to raise_error GitlabRuby::BadRequestError
    end

    it 'raises unauthorized error', vcr: true do
      invalid_client = GitlabRuby::Client.new(token: "INVALID KEY")
      expect{ invalid_client.post.projects.execute }.to raise_error GitlabRuby::UnauthorizedError
    end

    it 'raises forbidden error', vcr: true do
      expect{ client.put.projects.id(2868483).execute(name: "UPDATE") }.to raise_error GitlabRuby::ForbiddenError
    end

    it 'raises not found error', vcr: true do
      expect{ client.get.projects.id(100).execute }.to raise_error GitlabRuby::NotFoundError
    end

    it 'raises method not allowed error' do
      skip "NOT IMPLEMENTED"
    end

    it 'raises conflict error', vcr: true do
      expect{ client.put.projects.id(2868483).execute(name: "UPDATE") }.to raise_error GitlabRuby::ForbiddenError
    end

    it 'raises unprocessable error' do
      skip "NOT IMPLEMENTED"
    end

    it 'raises server error' do
      skip "NOT IMPLEMENTED"
    end
  end
end
