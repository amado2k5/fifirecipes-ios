import SwiftUI

/// Home: hero card from the "featured" feed row, then one horizontal rail
/// per feed row (featured, recent, per-chapter, kids).
struct HomeView: View {
    @EnvironmentObject private var app: AppState

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 26, pinnedViews: []) {
                hero
                ForEach(app.feed.rows, id: \.key) { row in
                    RailView(row: row)
                }
            }
            .padding(.bottom, 24)
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("homeScreen")
    }

    @ViewBuilder
    private var hero: some View {
        let featured = app.feed.rows.first { $0.key == "featured" }?.items ?? []
        if let id = featured.first, let card = app.index[id] {
            Button {
                app.homePath.append(AppRoute.recipe(card.id))
            } label: {
                ZStack(alignment: .bottomLeading) {
                    RemoteImage(url: heroURL(card))
                        .frame(height: 300)
                        .frame(maxWidth: .infinity)
                        .clipped()
                    LinearGradient(
                        colors: [.clear, Palette.ink.opacity(0.75)],
                        startPoint: .init(x: 0.5, y: 0.35), endPoint: .bottom)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(app.s[.tagline])
                            .fifiFont(.footnote, weight: .medium)
                            .foregroundStyle(.white.opacity(0.9))
                        Text(card.title)
                            .fifiFont(.title, weight: .heavy)
                            .foregroundStyle(.white)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        HStack(spacing: 8) {
                            MetaChip(text: card.prepTime ?? "", tone: .leaf)
                                .opacity(card.prepTime == nil ? 0 : 1)
                            MetaChip(text: card.cookTime ?? "", tone: .tomato)
                                .opacity(card.cookTime == nil ? 0 : 1)
                        }
                    }
                    .padding(20)
                }
            }
            .buttonStyle(.plain)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Palette.cardBorder, lineWidth: 1.5))
            .shadow(color: Palette.ink.opacity(0.10), radius: 15, y: 8)
            .padding(.horizontal)
            .accessibilityLabel(card.title)
        }
    }

    private func heroURL(_ card: RecipeCard) -> URL? {
        let info = app.images[card.id]
        return app.assetURL(info?.full2x ?? info?.full ?? card.image)
    }
}

/// One titled horizontal rail of recipe or kids cards.
struct RailView: View {
    @EnvironmentObject private var app: AppState
    let row: FeedRow

    var body: some View {
        if !row.items.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                Text(row.title)
                    .fifiFont(.title2, weight: .bold)
                    .foregroundStyle(Palette.ink)
                    .padding(.horizontal)
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 14) {
                        ForEach(row.items, id: \.self) { id in
                            railItem(id)
                        }
                    }
                    .scrollTargetLayout()
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                }
                .scrollTargetBehavior(.viewAligned)
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel(row.title)
        }
    }

    @ViewBuilder
    private func railItem(_ id: String) -> some View {
        if row.key == "kids" {
            if let card = app.kids[id] {
                Button {
                    app.homePath.append(AppRoute.kidsReady(card.id))
                } label: {
                    KidsCardView(card: card, minutesLabel: app.s[.minutesShort])
                        .frame(width: 200)
                        .kidsFontScope()
                }
                .buttonStyle(.plain)
            }
        } else if let card = app.index[id] {
            Button {
                app.homePath.append(AppRoute.recipe(card.id))
            } label: {
                RecipeCardView(card: card)
                    .frame(width: 200)
            }
            .buttonStyle(.plain)
        }
    }
}
