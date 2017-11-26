class DeciderApp < ApplicationRecord
  validates_presence_of :name, :web_url, :git_url
  belongs_to :team

  def dsn
    "#{web_url}decide"
  end

  def deploy_to_heroku
    tarball_of_github_repo = team.repository.gsub(/\.git$/, '/archive/master.tar.gz')
    build_url = HerokuService.new.create_build(name, tarball_of_github_repo)
    team.update!(last_deployment: build_url)
  end
end
