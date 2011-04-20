require "rubygems"
require "pivotal_tracker"
require "colored"
require "yaml"

class Runner
  def initialize(options)
    @project_name = options[:project]
    @owner = options[:owner]
    @state = options[:state]
    @token = options[:token]

    if @token.nil?
      load_config
    end

    @pt_client = PivotalTracker::Client.token = @token
    @pt_client = PivotalTracker::Client.use_ssl = @ssl

    @projects = PivotalTracker::Project.all

    @projects.each do |prj|
      if prj.name.downcase.eql? @project_name.downcase
        @prj_id = prj.id
      end
    end

    @project = PivotalTracker::Project.find(@prj_id)

  end

  def get_stories
    @project.stories.all(:current_state => @state, :owned_by => @owner).each do |story|
      puts "#{story.id.to_s.red} | #{story.name}"
    end
  end

  private

  def load_config
    config = YAML.load_file("#{ENV['HOME']}/.pivotcli.yml")
    @token = config['token']
    @ssl = config['ssl']
  end

end
