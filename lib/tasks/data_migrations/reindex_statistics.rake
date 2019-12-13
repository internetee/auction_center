namespace :data_migrations do
  task reindex_statistics: :environment do
    [Auction, Result, Invoice].each do |klass|
      puts "#{klass} is up to reindex!"
      klass.reindex
      puts "#{klass} reindexed"
    end
  end
end
