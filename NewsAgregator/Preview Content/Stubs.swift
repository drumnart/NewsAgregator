//
//  Stubs.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 30.04.2022.
//

import Foundation

struct Samples {
    
    static let calendar = Calendar.current

    static let sampleAPIItem1: NewsAPI.Article = {
        let dateComponents1 = DateComponents(calendar: calendar, year: 2022, month: 4, day: 25, hour: 20, minute: 57, second: 07)
        return NewsAPI.Article(
            source: NewsAPI.Source(id: "0", name: "The Next Web"),
            author: "Tristan Greene",
            title: "Analysis: Here’s what to expect now that Musk owns Twitter",
            description: "Elon Musk’s the topic du jour, once again, as his teased takeover of Twitter has come to its inevitable end. It’s a done deal: the world’s richest man has purchased Twitter. Cue the Imperial March. While we’re all waiting to see what happens now, it’s worth s…",
            url: "https://thenextweb.com/news/analysis-everything-you-need-know-about-musks-twitter-buyout",
            urlToImage: "https://img-cdn.tnwcdn.com/image/tnw?filter_last=1&fit=1280%2C640&url=https%3A%2F%2Fcdn0.tnwcdn.com%2Fwp-content%2Fblogs.dir%2F1%2Ffiles%2F2022%2F04%2Fmuskvader.jpg&signature=cd939b7c5dc99789d73bb52ebffdc7c3",
            publishedAt: calendar.date(from: dateComponents1),
            content: "lon Musks the topic du jour, once again, as his teased takeover of Twitter has come to its inevitable end.\r\nIts a done deal: the worlds richest man has purchased Twitter. Cue the Imperial March. \r\nW… [+5915 chars]"
        )
    }()

    static let sampleAPIItem2: NewsAPI.Article = {
        let dateComponents2 = DateComponents(calendar: calendar, year: 2022, month: 4, day: 25, hour: 20, minute: 44, second: 15)
        return NewsAPI.Article(
            source: NewsAPI.Source(id: "1", name: "TechCrunch"),
            author: "Sarah Perez",
            title: "Will advertisers flee a ‘free speech’ Twitter?",
            description: "New Twitter owner Elon Musk has emphasized his belief that “free speech” is critical to Twitter’s future, even noting in the press release announcing the deal today that “free speech is the bedrock of a functioning democracy.” But there is one significant com…",
            url: "https://techcrunch.com/2022/04/25/will-advertisers-flee-a-free-speech-twitter/",
            urlToImage: "https://techcrunch.com/wp-content/uploads/2013/02/twitter-ads-api.png?w=738",
            publishedAt: calendar.date(from: dateComponents2),
            content: "New Twitter owner Elon Musk has emphasized his belief that “free speech” is critical to Twitter’s future, even noting in the press release announcing the deal today that “free speech is the bedrock o… [+5306 chars]"
        )
    }()

    static let sampleAPIItem3: NewsAPI.Article = {
        let dateComponents3 = DateComponents(calendar: calendar, year: 2022, month: 4, day: 25, hour: 20, minute: 25, second: 33)
        return NewsAPI.Article(
            source: NewsAPI.Source(id: "2", name: "Test2"),
            author: "Ron Miller",
            title: "It’s Elon’s Twitter now, so what’s next?",
            description: "Twitter, the platform that once helped fuel The Arab Spring and Occupy Wall Street is now owned by the richest man in the world, and you have to wonder what impact it’s going to have. There are so many open questions about how the company will change under El…",
            url: "https://techcrunch.com/2022/04/25/its-elons-twitter-now-so-whats-next/",
            urlToImage: "https://techcrunch.com/wp-content/uploads/2022/04/GettyImages-1239926796.jpg?w=600",
            publishedAt: calendar.date(from: dateComponents3),
            content: "Twitter, the platform that once helped fuel The Arab Spring and Occupy Wall Street is now owned by the richest man in the world, and you have to wonder what impact it’s going to have.\r\nThere are so m… [+4603 chars]"
        )
        
    }()

    static let sampleAPIItem4: NewsAPI.Article = {
        let dateComponents = DateComponents(calendar: calendar, year: 2022, month: 4, day: 25, hour: 20, minute: 58, second: 10)
        return NewsAPI.Article(
            source: NewsAPI.Source(id: "4", name: "TechCrunch"),
            author: "Ron Miller",
            title: "It’s Elon’s Twitter now, so what’s next?",
            description: "Twitter, the platform that once helped fuel The Arab Spring and Occupy Wall Street is now owned by the richest man in the world, and you have to wonder what impact it’s going to have. There are so many open questions about how the company will change under El…",
            url: "https://techcrunch.com/2022/04/25/its-elons-twitter-now-so-whats-next/",
            urlToImage: "https://techcrunch.com/wp-content/uploads/2022/04/GettyImages-1239926796.jpg?w=600",
            publishedAt: calendar.date(from: dateComponents),
            content: "Twitter, the platform that once helped fuel The Arab Spring and Occupy Wall Street is now owned by the richest man in the world, and you have to wonder what impact it’s going to have.\r\nThere are so m… [+4603 chars]"
        )
    }()

    static let sampleAPIItem5: NewsAPI.Article = {
        let dateComponents = DateComponents(calendar: calendar, year: 2022, month: 4, day: 26, hour: 16, minute: 05, second: 28)
        return NewsAPI.Article(
            source: NewsAPI.Source(id: "the-verge", name: "the-verge"),
            author: "Jon Porter",
            title: "Emoji reactions are sliding into Twitter’s DMs - The Verge",
            description: "Twitter’s direct messages now support emoji reactions. To use them, you can either tap the small “heart and plus icon” that appears to the right of messages you receive, or double tap a message on mobile.",
            url: "",
            urlToImage: "https://s.abcnews.com/images/Business/WireAP_6b82fe19ed404b0b8e96c9f4c9371e7c_16x9_992.jpg",
            publishedAt: calendar.date(from: dateComponents),
            content: ""
        )
    }()

    static let sampleArray1: [NewsAPI.Article] = [sampleAPIItem1, sampleAPIItem2, sampleAPIItem3]
    static let sampleArray2: [NewsAPI.Article] = [sampleAPIItem4, sampleAPIItem5]
}
