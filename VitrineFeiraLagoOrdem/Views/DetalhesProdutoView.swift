//
//  DetalhesProdutoView.swift
//  VitrineFeiraLagoOrdem
//
//  Tela de detalhes de um produto.
//

import SwiftUI

struct DetalhesProdutoView: View {
    let produto: ProdutoArtesanal
    let viewModel: VitrineViewModel
    @State private var mostrandoContato = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                imagemAmpliada
                    // Prioridade menor: o VoiceOver lê a imagem DEPOIS do nome.
                    .accessibilitySortPriority(0)

                VStack(alignment: .leading, spacing: 8) {
                    Text(produto.nome)
                        .font(.largeTitle.bold())
                        .fixedSize(horizontal: false, vertical: true)
                        // Prioridade maior: lido ANTES da imagem.
                        .accessibilitySortPriority(10)

                    Label(produto.artesao, systemImage: "person.fill")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .accessibilityLabel("Artesão: \(produto.artesao)")

                    Text(produto.categoria)
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(Capsule())
                        .accessibilityLabel("Categoria: \(produto.categoria)")
                }

                Text(produto.precoFormatado)
                    .font(.title.bold())
                    .foregroundStyle(.tint)
                    .accessibilityLabel("Preço: \(produto.precoFormatado)")

                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Sobre a peça")
                        .font(.title3.bold())
                    Text(produto.descricao)
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                }

                botaoContato
            }
            .padding()
        }
        .navigationTitle(produto.nome)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.alternarFavorito(produto)
                } label: {
                    Image(systemName: viewModel.isFavorito(produto) ? "heart.fill" : "heart")
                        .foregroundStyle(viewModel.isFavorito(produto) ? .red : .gray)
                        .frame(minWidth: 44, minHeight: 44)
                }
                .accessibilityLabel(
                    viewModel.isFavorito(produto)
                    ? "Remover dos favoritos"
                    : "Adicionar aos favoritos"
                )
            }
        }
        .alert("Contato enviado!", isPresented: $mostrandoContato) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Sua mensagem para \(produto.artesao) foi enviada. "
                 + "Em breve o artesão entrará em contato.")
        }
    }

    // MARK: - Imagem ampliada

    private var imagemAmpliada: some View {
        Group {
            if UIImage(named: produto.imagemNome) != nil {
                Image(produto.imagemNome)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(systemName: produto.imagemNome)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(48)
                    .foregroundStyle(.tint)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 260)
        .clipped()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .accessibilityLabel(produto.rotuloImagem)
    }

    // MARK: - Botão de contato (fictício)

    private var botaoContato: some View {
        Button {
            mostrandoContato = true
        } label: {
            Label("Entrar em contato com o Artesão", systemImage: "envelope.fill")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 44)
        }
        .buttonStyle(.borderedProminent)
        .padding(.top, 8)
    }
}

#Preview {
    NavigationStack {
        DetalhesProdutoView(
            produto: ProdutoArtesanal.exemplos[0],
            viewModel: VitrineViewModel()
        )
    }
}
