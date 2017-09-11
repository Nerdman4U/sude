namespace :deploy do
  task :seed do
    on roles(:all) do
      within "#{release_path}" do
        with rails_env: "#{fetch(:stage)}" do
          execute :rake, "db:seed"
        end
      end
    end
  end
end
after "deploy:migrate", "deploy:seed"
