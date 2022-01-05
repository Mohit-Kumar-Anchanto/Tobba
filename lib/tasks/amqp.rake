desc "Run all of your sneakers tasks"
task :amqp => :environment do
  ProductWorker
  # MyRandomWorker
  # MyOtherSneakersWorker
  Rake::Task["sneakers:run"].invoke
end