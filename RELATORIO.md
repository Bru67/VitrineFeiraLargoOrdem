# Relatório Técnico — Vitrine Virtual da Feira do Largo da Ordem

**Disciplina:** Desenvolvimento iOS — PUCPR
**Projeto:** Vitrine Virtual de Produtos Artesanais (com foco em Acessibilidade)

> Este arquivo é o rascunho do relatório. Preencha os nomes da equipe e ajuste
> os textos conforme a experiência de vocês, depois exporte para **PDF**.

---

## 1. Integrantes do grupo

| Nome completo | Função / contribuição principal |
|---|---|
| _(Integrante 1)_ | _(ex: Model e dados)_ |
| _(Integrante 2)_ | _(ex: Vitrine e grid)_ |
| _(Integrante 3)_ | _(ex: Tela de detalhes)_ |
| _(Integrante 4)_ | _(ex: Acessibilidade)_ |
| _(Integrante 5)_ | _(ex: Busca e favoritos)_ |

---

## 2. Arquitetura utilizada

O aplicativo foi estruturado seguindo o padrão **MVVM (Model–View–ViewModel)**,
que é o padrão idiomático para projetos em SwiftUI.

### 2.1 Camadas

- **Model (`ProdutoArtesanal`)** — `struct` que conforma a `Identifiable`,
  representando um produto da feira. Além dos dados, contém propriedades
  computadas como `precoFormatado` (formatação monetária em Real) e
  `rotuloImagem` (descrição para acessibilidade).

- **DataSource (`ProdutosMock`)** — `extension` do Model que fornece a lista de
  produtos de exemplo. Separar os dados do Model facilita a futura troca por uma
  API ou banco de dados.

- **ViewModel (`VitrineViewModel`)** — classe marcada com `@Observable` que
  centraliza o **estado e a lógica de negócio**: a lista de produtos, o texto de
  busca, a filtragem e a alternância de favoritos. É a *fonte única de verdade*.

- **Views** — componentes de interface, sem lógica de negócio:
  - `VitrineView`: tela principal com a grade e a busca.
  - `ProdutoCardView`: card reutilizável de cada produto.
  - `DetalhesProdutoView`: tela de detalhes.

### 2.2 Fluxo de dados

```
ProdutosMock (dados)
      │
      ▼
VitrineViewModel  ◄── @Observable (estado reativo)
      │
      ▼
VitrineView ──► ProdutoCardView
      │
      └──► DetalhesProdutoView
```

A `VitrineView` cria e mantém o ViewModel com `@State`. Ao favoritar um item, o
ViewModel altera o array `produtos`; como ele é `@Observable`, a SwiftUI
re-renderiza automaticamente apenas as views afetadas, mantendo a interface
sincronizada (o coração muda de estado imediatamente, na vitrine e nos detalhes).

### 2.3 Por que MVVM (e não MVC)?

Em SwiftUI a própria View já é declarativa e reativa. Concentrar o estado e a
lógica no ViewModel deixa as Views **enxutas, testáveis e reutilizáveis**, evita
duplicação de regras (ex: o estado de favorito é o mesmo na vitrine e nos
detalhes) e separa claramente responsabilidades.

---

## 3. Decisões de design de interface (UI) e experiência (UX)

### 3.1 Grade adaptativa e responsividade

Usamos `LazyVGrid` com `GridItem(.adaptive(minimum: 150))` dentro de um
`ScrollView`. Isso faz o **número de colunas se ajustar automaticamente** ao
tamanho da tela — mais colunas no iPad, menos no iPhone — sem nenhum código
condicional por dispositivo. O `Lazy` garante que apenas as células visíveis
sejam renderizadas, melhorando o desempenho com muitos produtos.

### 3.2 Padronização das imagens

Cada imagem usa `.aspectRatio(contentMode: .fit/.fill)` com `.clipped()` e altura
fixa, garantindo cards visualmente alinhados independentemente do conteúdo.
Implementamos uma **estratégia de imagem mista (degradação graciosa)**: o app
tenta carregar uma imagem real dos Assets e, se não existir, usa um **SF Symbol**
como *fallback*. Assim o app nunca quebra por imagem ausente.

### 3.3 Card componentizado

O card foi extraído para uma View separada (`ProdutoCardView`), recebendo os
dados por parâmetro e uma *closure* (`aoFavoritar`) para a ação do botão. Isso
torna o componente reutilizável e mantém a `VitrineView` legível.

### 3.4 Hierarquia visual e navegação

- Tela de detalhes com imagem ampliada, hierarquia tipográfica clara (título,
  artesão, categoria em *chip*, preço em destaque) e um **botão de ação primário**
  (`.borderedProminent`) para "Entrar em contato com o Artesão".
- Feedback ao usuário via `.alert` ao acionar o contato.
- Estado vazio amigável na busca (`ContentUnavailableView`).

---

## 4. Acessibilidade (A11y)

A acessibilidade foi um requisito central, valendo 30% da avaliação. Decisões:

| Diretriz | Implementação |
|---|---|
| **Rótulos de imagem (VoiceOver)** | Cada imagem tem `.accessibilityLabel` descrevendo a peça (ex: "Escultura de madeira em formato de capivara"), via a propriedade `rotuloImagem` do Model. |
| **Leitura de preços** | O texto do preço usa `.accessibilityLabel("Preço: \(precoFormatado)")`, evitando que o VoiceOver leia "R cifrão". |
| **Área de toque (44 pt)** | O botão de favoritar usa `.frame(minWidth: 44, minHeight: 44)`, atendendo às *Human Interface Guidelines* da Apple para usuários com dificuldade motora. |
| **Dynamic Type** | Nenhum texto usa altura fixa (`.frame(height:)`). Usamos `.fixedSize(horizontal: false, vertical: true)` para os textos crescerem e quebrarem linha quando o usuário aumenta a fonte do sistema. |
| **Ordem de leitura** | Na tela de detalhes, `.accessibilitySortPriority` garante que o VoiceOver leia o **nome do produto antes da imagem**. |
| **Rótulos de ação** | O botão de favoritar descreve a ação contextual ("Adicionar X aos favoritos" / "Remover X dos favoritos"). |

---

## 5. Gerenciamento de estado

O estado de favorito é mantido no **ViewModel** (`@Observable`), e não em `@State`
local de cada card. Essa decisão é proposital: o favorito precisa ser consistente
entre a vitrine e a tela de detalhes. Como há uma única fonte de verdade, ao
favoritar em qualquer tela a alteração se reflete imediatamente em todas as
outras, sem sincronização manual.

---

## 6. Dificuldades encontradas e soluções

> _Ajustem esta seção com o que vocês realmente enfrentaram. Sugestões reais:_

1. **Botão dentro de um item navegável.**
   O card inteiro é um `NavigationLink`, mas o botão de favoritar não pode
   disparar a navegação. *Solução:* aplicar `.buttonStyle(.plain)` no link e usar
   um `Button` próprio para o coração, que intercepta o toque sem navegar.

2. **VoiceOver lendo o preço incorretamente.**
   O leitor de tela lia "R cifrão quarenta e cinco". *Solução:* separar o rótulo
   de acessibilidade do texto visual com `.accessibilityLabel`.

3. **Caminhos absolutos no projeto.**
   O `.xcodeproj` foi gerado com caminhos absolutos da máquina original, o que
   quebraria ao clonar em outro Mac. *Solução:* converter para caminhos relativos
   no `project.pbxproj`.

4. **Desenvolvimento remoto (MacinCloud) + Git.**
   Trabalho coordenado via GitHub com push/pull; autenticação por *token* em vez
   de senha; integração de commits paralelos via *rebase*.

---

## 7. Conclusão

O aplicativo atende a todos os requisitos propostos: grade adaptativa, navegação,
gerenciamento de estado de favoritos, busca, e — principalmente — um conjunto
robusto de recursos de acessibilidade que tornam a vitrine utilizável por pessoas
com deficiências visuais ou motoras.
