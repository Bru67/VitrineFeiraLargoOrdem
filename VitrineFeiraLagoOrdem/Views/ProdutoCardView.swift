//
//  ProdutoCardView.swift
//  VitrineFeiraLagoOrdem
//
//  Card reutilizável de um produto na grade da vitrine.
//

import SwiftUI

struct ProdutoCardView: View {
    let produto: ProdutoArtesanal
    let isFavorito: Bool
    let aoFavoritar: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                imagemProduto
                botaoFavoritar
            }

            Text(produto.nome)
                .font(.headline)
                .lineLimit(2)
                // Permite que o texto cresça e quebre linha com Dynamic Type.
                .fixedSize(horizontal: false, vertical: true)

            Text(produto.categoria)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(produto.precoFormatado)
                .font(.subheadline.bold())
                // Evita o VoiceOver ler "R cifrão" — lê "Preço: 89 reais e 90 centavos".
                .accessibilityLabel("Preço: \(produto.precoFormatado)")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Imagem

    private var imagemProduto: some View {
        Group {
            if UIImage(named: produto.imagemNome) != nil {
                // Foto real adicionada aos Assets.
                Image(produto.imagemNome)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                // Fallback: SF Symbol.
                Image(systemName: produto.imagemNome)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(28)
                    .foregroundStyle(.tint)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 130)
        .clipped()
        .background(Color(.tertiarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        // Descreve a peça para o VoiceOver.
        .accessibilityLabel(produto.rotuloImagem)
    }

    // MARK: - Botão favoritar

    private var botaoFavoritar: some View {
        Button(action: aoFavoritar) {
            Image(systemName: isFavorito ? "heart.fill" : "heart")
                .font(.title3)
                .foregroundStyle(isFavorito ? .red : .gray)
                .padding(8)
                .background(.thinMaterial, in: Circle())
                // Área de toque mínima de 44x44 pontos (acessibilidade motora).
                .frame(minWidth: 44, minHeight: 44)
        }
        .buttonStyle(.plain)
        .padding(4)
        .accessibilityLabel(
            isFavorito
            ? "Remover \(produto.nome) dos favoritos"
            : "Adicionar \(produto.nome) aos favoritos"
        )
    }
}

#Preview {
    ProdutoCardView(
        produto: ProdutoArtesanal.exemplos[0],
        isFavorito: true,
        aoFavoritar: {}
    )
    .frame(width: 180)
    .padding()
}
