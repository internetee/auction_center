module Username
  class GenerateUsernameService
    def call
      [elder_scrolls,
       sillicon_valley,
       beer,
       funny_name_two_word,
       funny_name_three_word,
       fruits,
       dish].sample
    end

    def elder_scrolls
      Faker::Games::ElderScrolls.first_name +
        Faker::Games::ElderScrolls.last_name
    end

    def sillicon_valley
      Faker::TvShows::SiliconValley.character
    end

    def beer
      Faker::Beer.name
    end

    def funny_name_two_word
      Faker::FunnyName.two_word_name
    end

    def funny_name_three_word
      Faker::FunnyName.three_word_name
    end

    def fruits
      Faker::Food.fruits
    end

    def dish
      Faker::Food.dish
    end
  end
end
