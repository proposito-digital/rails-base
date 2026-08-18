# Checklist de Evolução do Rails Base

Este checklist reúne as melhorias prioritárias para manter o Rails Base como uma base segura, testável e reutilizável para novos projetos.

## Prioridade 0 — Confiabilidade da base

### Testes e integração contínua

- [x] Definir o RSpec como a única suíte de testes oficial.
- [x] Migrar ou remover os testes Minitest legados em `test/`.
- [x] Atualizar a GitHub Actions para executar `bundle exec rspec`.
- [x] Garantir que Brakeman, RuboCop e RSpec sejam obrigatórios em pull requests.
- [x] Documentar os comandos locais de qualidade: setup, lint, segurança e testes.

**Concluído quando:** um pull request só fica verde depois de todas as verificações passarem, e a CI executa a mesma suíte usada no desenvolvimento.

### Autorização

- [x] Passar `Current.user` para o Pundit em vez de um valor fixo.
- [x] Alterar a política-base para negar ações por padrão.
- [x] Definir o modelo inicial de acesso, por exemplo administrador e usuário comum.
- [x] Remover a dependência fixa de `DogPolicy` do controller administrativo genérico.
- [x] Habilitar verificações de autorização e escopo do Pundit nos controllers.
- [x] Cobrir cenários autorizados e não autorizados com testes.

**Concluído quando:** usuários sem permissão não conseguem acessar, listar ou modificar recursos administrativos.

## Prioridade 1 — Experiência de bootstrap

### Autenticação e usuários

- [x] Revisar os fluxos de criação, edição e remoção de usuários.
- [x] Decidir se perfis/papéis fazem parte do padrão do Rails Base.
- [x] Cobrir login, logout, recuperação de senha e permissões com testes de integração.
- [x] Revisar mensagens, limites de tentativas e comportamento de sessão.

**Concluído quando:** os fluxos essenciais de acesso têm comportamento definido e cobertura automatizada.

### Guia de uso do template

- [x] Documentar como criar um novo projeto a partir desta base.
- [x] Documentar como renomear a aplicação, serviço Kamal e imagem Docker.
- [x] Documentar credenciais, variáveis de ambiente e configuração de e-mail.
- [x] Documentar setup local, Dev Container e comandos de desenvolvimento.
- [x] Adicionar checklist de primeiro deploy.
- [x] Adicionar checklist de revisão antes da entrega de um projeto novo.

**Concluído quando:** uma pessoa consegue iniciar, configurar e publicar um projeto sem conhecimento informal da equipe.

### Limpeza de referências herdadas

- [x] Remover ou generalizar textos, traduções e conceitos específicos de outros produtos.
- [x] Revisar exemplos de entidades, menus, seeds e imagens que não pertencem ao núcleo da base.
- [x] Manter exemplos mínimos que ilustrem o CRUD administrativo sem impor regras de domínio.

**Concluído quando:** o repositório comunica apenas os conceitos realmente oferecidos pelo template.

## Prioridade 2 — Segurança e operação

### Segurança padrão

- [x] Configurar uma Content Security Policy compatível com Importmap e os recursos usados pela interface.
- [x] Revisar configuração de hosts, HTTPS, cookies e cabeçalhos de segurança em produção.
- [x] Documentar o gerenciamento de `RAILS_MASTER_KEY` e demais segredos.
- [x] Manter Brakeman e auditoria de dependências ativos na CI.

**Concluído quando:** novos projetos iniciam com configurações seguras e segredos não dependem de passos implícitos.

### Infraestrutura e dados

- [x] Documentar quando SQLite é adequado para produção.
- [x] Documentar o caminho recomendado para PostgreSQL em projetos que exigem maior concorrência ou alta disponibilidade.
- [x] Documentar backup e restauração do volume persistente de produção.
- [x] Substituir exemplos pendentes de host, domínio e imagem no Kamal por instruções claras de configuração.
- [x] Testar o processo de deploy em um ambiente de homologação.

**Concluído quando:** o caminho de produção, recuperação e evolução do banco está explícito.

## Prioridade 3 — Manutenção da plataforma

### Versões e dependências

- [x] Alinhar versões de Ruby e Rails entre README, Gemfile, Dockerfile e arquivos de configuração.
- [x] Avaliar a atualização de `config.load_defaults` para a versão atual do Rails.
- [x] Definir política de atualização de dependências e revisão dos pull requests do Dependabot.
- [ ] Registrar atualizações relevantes no changelog.

**Concluído quando:** documentação, ambiente de desenvolvimento, CI e produção usam a mesma linha-base tecnológica.
