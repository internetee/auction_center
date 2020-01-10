class BanGenerator

  def self.generate! count
    users = User.participant.sample count
    users.each_with_index do |user, index|
      index.times do
        create_ban(user)
      end
    end
  end

  def self.create_ban(user)
    Ban.create(user: user,
               valid_from: Time.zone.now - 1.week,
               valid_until: Time.zone.now + 1.week,
               domain_name: domain_name.sample)
  end

  def self.domain_name
    [Auction.all.sample.domain_name, nil]
  end
end

BanGenerator.generate! 7
