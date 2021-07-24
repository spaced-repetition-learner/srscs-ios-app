//
//  DeckViewModel.swift
//  SRL
//
//  Created by Daniel Koellgen on 25.05.21.
//

import Foundation
import Combine

class DeckViewModel: ObservableObject {
    private let deckService = DeckService()
    private var deckObserver: AnyCancellable?

    @Published private (set) var deck: Deck
    private (set) var reviewQueue: ReviewQueue


    init(deck: Deck) {
        self.deck = deck
        self.reviewQueue = DeckViewModel.getDefaultReviewQueue(deck: deck)
        deckObserver = deckService.getModelPublisher().sink(receiveValue: decksUpdatedCallback)
    }


    
    func editDeck(name: String, presetId: UUID) {
        if deck.name != name {
            deckService.renameDeck(forId: deck.id, withName: name)
        }
        if deck.schedulePreset.id != presetId {
            deckService.updateSchedulePreset(forId: deck.id, withPresetId: presetId)
        }
    }

    func dropDeck(id: UUID) {
        deckService.deleteDeck(forId: id)
    }
    
    func getSortedCards(sort: (Card, Card) -> Bool) -> [Card] {
        deck.cards.map { (key: UUID, value: Card) in
            value
        }.sorted(by: sort)
    }
    
    func deleteCards(indexSet: IndexSet) {
        let cards: [Card] = deck.cards.map { (key: UUID, value: Card) in value }
        for index in indexSet {
            deckService.deleteCard(forDeckId: deck.id, withCardId: cards[index].id)
        }
    }

    
    
    private func decksUpdatedCallback(decks: [UUID:Deck]) {
        if let deck: Deck = deckService.getDeck(inDictionary: decks, forKey: self.deck.id) {
            self.deck = deck
            self.reviewQueue = DeckViewModel.getDefaultReviewQueue(deck: deck)
        } else {
            deckObserver?.cancel()
        }
    }
    
    private static func getDefaultReviewQueue(deck: Deck) -> ReviewQueue {
        ReviewQueueService().makeTransientQueue(decks: [deck], reviewType: .REGULAR)
    }
    
    static func sortByDateCardCreatedNewToOld(lhs: Card, rhs: Card) -> Bool {
        lhs.dateCreated > rhs.dateCreated
    }
}