import 'package:flutter/material.dart';
import 'barraLateral.dart';
import 'globalResponsivo.dart';

class LayoutMenu extends StatefulWidget {
  List<Widget> widgetsAcao;
  List<ItemMenu> pages;
  String nomeApp;
  String versaoApp;
  String logo;
  Widget botaoAcao;
  List<Color> coresMenu;
  Widget logoutPage;

  LayoutMenu({
    this.widgetsAcao,
    @required this.pages,
    @required this.nomeApp,
    @required this.versaoApp,
    @required this.logo,
    this.botaoAcao,
    this.coresMenu,
    @required this.logoutPage,
  });

  @override
  _LayoutMenuState createState() => _LayoutMenuState();
}

class _LayoutMenuState extends State<LayoutMenu> {
  int paginaAtual = 0;

  @override
  void initState() {
    super.initState();

    if (widget.coresMenu[0] != null) corAppBarConteudo = widget.coresMenu[0];
    if (widget.coresMenu[1] != null) corAppBarMenu = widget.coresMenu[1];
    if (widget.coresMenu[2] != null) corMenuConteudo = widget.coresMenu[2];

    widget.pages.add(ItemMenu(
      icone: Icons.exit_to_app,
      visivel: true,
      titulo: 'Logout',
      pagina: Container(),
      submenu: null,
    ));

    controladorPaginas.addListener(() {
      if (controladorPaginas.page.round() != paginaAtual) {
        setState(() {
          paginaAtual = controladorPaginas.page.round();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.botaoAcao,
      body: GestureDetector(
        onHorizontalDragEnd: (mov) {
          if (mov.primaryVelocity > 0) {
            openMenu = true;
            controllerAnimacao.add(true);
          } else {
            openMenu = false;
            controllerAnimacao.add(true);
          }
        },
        child: _body(),
      ),
    );
  }

  _body() {
    return Stack(
      children: [
        Scaffold(
          appBar: _appBar(),
          body: Padding(
            padding: const EdgeInsets.only(left: 65),
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: controladorPaginas,
              children: [
                for (int k = 0; k < widget.pages.length; k++)
                  widget.pages[k].submenu == null ? pagina(widget.pages[k]) : _subList(widget.pages[k], k)
              ],
            ),
          ),
        ),
        StreamBuilder(
          stream: controllerAnimacao.stream,
          builder: (context, child) {
            return AnimatedPositioned(
              left: MediaQuery.of(context).size.width > 770
                  ? 0
                  : openMenu
                      ? 0
                      : -65,
              height: MediaQuery.of(context).size.height,
              duration: Duration(milliseconds: tempoAnimacao),
              child: AnimatedContainer(
                duration: Duration(milliseconds: tempoAnimacao),
                width: openMenu ? 300 : 65, //sizeWidthMenu
                height: 100,
                color: corAppBarMenu,
                child: BarraLateral(
                  logo: widget.logo,
                  nomeApp: widget.nomeApp,
                  versao: widget.versaoApp,
                  pages: widget.pages,
                  logoutPage: widget.logoutPage,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget pagina(ItemMenu e) {
    controladorSubs.add(PageController(initialPage: 0));
    return e.pagina;
  }

  _appBar() {
    return AppBar(
      actions: widget.widgetsAcao,
      title: Row(
        children: [
          StreamBuilder(
            stream: controllerAnimacao.stream,
            builder: (context, child) {
              return AnimatedPadding(
                duration: Duration(milliseconds: tempoAnimacao),
                padding: EdgeInsets.only(left: openMenu ? 292 : 57, right: 16),
                child: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      openMenu = !openMenu;
                      controllerAnimacao.add(true);
                    }),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text(widget.pages[paginaAtual].titulo),
          ),
        ],
      ),
      backgroundColor: corAppBarConteudo,
    );
  }

  Widget _subList(ItemMenu e, index) {
    controladorSubs.add(PageController(initialPage: 0));
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: controladorSubs[index],
      children: e.submenu.map((pag) => pag.pagina).toList(),
    );
  }
}

class ItemMenu {
  IconData icone;
  bool visivel;
  String titulo;
  Widget pagina;
  List<ItemMenu> submenu;

  ItemMenu({@required this.icone, @required this.visivel, @required this.titulo, @required this.pagina, @required this.submenu});
}

class AcaoMenu {
  static void atualizar() {
    controllerAnimacao.add(true);
  }

  static getPage() {
    return controladorPaginas.page;
  }

  static void goTo(int pageIndex) {
    controladorPaginas.jumpToPage(pageIndex);
  }
}
