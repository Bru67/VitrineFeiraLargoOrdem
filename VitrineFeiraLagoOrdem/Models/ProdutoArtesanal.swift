//
//  ProdutoArtesanal.swift
//  VitrineFeiraLagoOrdem
//
//  Modelo de dados de um produto da Feira do Largo da Ordem.
//

import Foundation

struct ProdutoArtesanal: Identifiable {
    let id: UUID
    let nome: String
    let artesao: String
    let preco: Double
    let categoria: String
    let imagemNome: String
    let descricao: String
    var isFavorito: Bool

    /// Descrição rica da imagem para leitores de tela (VoiceOver).
    /// Ex: "Escultura de madeira em formato de capivara".
    let imagemAcessivel: String

    init(
        id: UUID = UUID(),
        nome: String,
        artesao: String,
        preco: Double,
        categoria: String,
        imagemNome: String,
        descricao: String,
        imagemAcessivel: String = "",
        isFavorito: Bool = false
    ) {
        self.id = id
        self.nome = nome
        self.artesao = artesao
        self.preco = preco
        self.categoria = categoria
        self.imagemNome = imagemNome
        self.descricao = descricao
        self.imagemAcessivel = imagemAcessivel
        self.isFavorito = isFavorito
    }

    /// Preço formatado em Real brasileiro (ex: "R$ 45,00").
    var precoFormatado: String {
        preco.formatted(.currency(code: "BRL").locale(Locale(identifier: "pt_BR")))
    }

    /// Rótulo usado no `.accessibilityLabel` das imagens.
    /// Usa a descrição rica se houver; caso contrário, o próprio nome.
    var rotuloImagem: String {
        imagemAcessivel.isEmpty ? nome : imagemAcessivel
    }
}
