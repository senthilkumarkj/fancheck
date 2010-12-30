namespace :bootstrap do
      desc "Add the default user"
      task :default_user => :environment do
        user = User.create( :twitter_id => GUEST_TWTTR_ID, :oauth_token => '154839081-g89JiZBF5wTiyqtXw9FKSAjQa6mOtaUHFxfz3uHW', :oauth_token_secret => '208snhxVMGra6TRJPoYuBGR5S1HQtLyZ04h70ONc', :mode=> DEFAULT_MODE )
        user.save
      end

      desc "Run all bootstrapping tasks"
      task :all => [:default_user]
      end

