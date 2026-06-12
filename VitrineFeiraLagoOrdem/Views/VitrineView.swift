//
//  VitrineView.swift
//  VitrineFeiraLagoOrdem
//
//  Tela principal: grade adaptativa de produtos com busca.
//

import SwiftUI

struct VitrineView: View {
    @State private var viewModel = VitrineViewModel()

    // Grade adaptativa: o nº de colunas se ajusta ao iPhone/iPad.
    private let colunas = [GridItem(.adaptive(minimum: 150), spacing: 16)]

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationStack {
            ScrollView {
                LazyVGrid(columns: colunas, spacing: 16) {
                    ForEach(viewModel.produtosFiltrados) { produto in
                        NavigationLink {
                            DetalhesProdutoView(produto: produto, viewModel: viewModel)
                        } label: {
                            ProdutoCardView(
                                produto: produto,
                                isFavorito: viewModel.isFavorito(produto),
                                aoFavoritar: { viewModel.alternarFavorito(produto) }
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("Feira do Largo da Ordem")
            .searchable(
                text: $viewModel.textoBusca,
                prompt: "Buscar por nome ou categoria"
            )
            .overlay {
                if viewModel.produtosFiltrados.isEmpty {
                    ContentUnavailableView.search(text: viewModel.textoBusca)
                }
            }
        }
    }
}

#Preview {
    VitrineView()
}
