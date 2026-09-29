import SwiftUI

/// Chapters tab: grid of chapter cards.
struct ChaptersView: View {
    @EnvironmentObject private var app: AppState

    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 250), spacing: 14)],
                spacing: 14
            ) {
                ForEach(app.chapters) { chapter in
                    Button {
                        app.chaptersPath.append(AppRoute.chapter(chapter.id))
                    } label: {
                        ChapterCardView(chapter: chapter)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("chaptersScreen")
    }
}

/// Chapter detail: virtualized grid of the chapter's recipes — chapters can
/// hold 300+ cards, so LazyVGrid does the windowing.
struct ChapterDetailView: View {
    @EnvironmentObject private var app: AppState
    let chapterID: Int

    private var cards: [RecipeCard] {
        app.index.values.filter { $0.chapter == chapterID }
            .sorted { $0.id < $1.id }
    }

    private var title: String {
        app.chapters.first { $0.id == chapterID }?.name
            ?? cards.first?.chapterName
            ?? app.s[.chapters]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(title)
                        .fifiFont(.title, weight: .heavy)
                        .foregroundStyle(Palette.ink)
                    Spacer()
                    Text("\(cards.count)")
                        .fifiFont(.callout, weight: .medium)
                        .foregroundStyle(Palette.leafDeep)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(Palette.leafSoft, in: Capsule())
                }
                .padding(.horizontal)

                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 160), spacing: 14)],
                    spacing: 14
                ) {
                    ForEach(cards) { card in
                        Button {
                            app.chaptersPath.append(AppRoute.recipe(card.id))
                        } label: {
                            RecipeCardView(card: card)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("chapterDetail")
    }
}
