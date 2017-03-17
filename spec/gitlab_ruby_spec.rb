require 'spec_helper'

describe GitlabRuby do
  it 'has a version number' do
    expect(GitlabRuby::VERSION).not_to be nil
  end

  it 'get single project', vcr: true do
    client = GitlabRuby::Client.new(token: TEST_API_KEY)
    # GitlabRuby::Client.debug = true
    project = client.get.version('v4').projects.id(2868483).execute
    expect(project.name).to eq 'rn.absent'
  end

  it 'does not chain non stop' do
    client = GitlabRuby::Client.new(token: TEST_API_KEY)
    # GitlabRuby::Client.debug = true
    project1 = client.get.projects.id(2868483)
    project2 = client.get.version('v4').projects.id(2868483)
    expect(project1.urlstring).to eq 'projects/2868483/'
    expect(project2.urlstring).to eq 'v4/projects/2868483/'
  end
end
