import 'package:flutter/material.dart';
import 'barraLateral.dart';
import 'globalResponsivo.dart';

class LayoutMenu extends StatefulWidget {
  List<Widget> widgetsAcao;
  List<NavMenu> pages;
  String nomeApp;
  String versaoApp;
  String logo;
  Widget botaoAcao;
  Color appBarColor;
  Color navColor;
  Color headerColor;
  Color textAppBarColor;
  Color textnavColor;
  Color textHeaderColor;
  Color selectedColor;
  Widget logoutPage;

  LayoutMenu({
    this.widgetsAcao,
    @required this.pages,
    @required this.nomeApp,
    @required this.versaoApp,
    @required this.logo,
    this.botaoAcao,
    this.appBarColor,
    this.headerColor,
    this.navColor,
    this.textAppBarColor,
    this.textHeaderColor,
    this.textnavColor,
    this.selectedColor,
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

    if (widget.appBarColor != null) appBarColor = widget.appBarColor;
    if (widget.headerColor != null) headerColor = widget.headerColor;
    if (widget.navColor != null) navColor = widget.navColor;
    if (widget.textAppBarColor != null) textAppBarColor = widget.textAppBarColor;
    if (widget.textHeaderColor != null) textHeaderColor = widget.textHeaderColor;
    if (widget.textnavColor != null) textnavColor = widget.textnavColor;
    if (widget.selectedColor != null) selectedColor = widget.selectedColor;

    widget.pages.add(NavMenu(
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
            activeMenu = true;
            controllerAnimacao.add(true);
          } else {
            activeMenu = false;
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
              left: checkPlatformSize(context)
                  ? 0
                  : activeMenu
                      ? 0
                      : -65,
              height: MediaQuery.of(context).size.height,
              duration: Duration(milliseconds: tempoAnimacao),
              child: AnimatedContainer(
                duration: Duration(milliseconds: tempoAnimacao),
                width: activeMenu ? 300 : 65,
                height: 100,
                color: navColor,
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

  Widget pagina(NavMenu e) {
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
                padding: EdgeInsets.only(
                    left: checkPlatformSize(context)
                        ? activeMenu
                            ? 292
                            : 57
                        : activeMenu
                            ? 292
                            : 0,
                    right: 16),
                child: IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: textAppBarColor,
                    ),
                    onPressed: () {
                      activeMenu = !activeMenu;
                      controllerAnimacao.add(true);
                    }),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text(
              widget.pages[paginaAtual].titulo,
              style: TextStyle(color: textAppBarColor),
            ),
          ),
        ],
      ),
      backgroundColor: appBarColor,
    );
  }

  Widget _subList(NavMenu e, index) {
    controladorSubs.add(PageController(initialPage: 0));
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: controladorSubs[index],
      children: e.submenu.map((pag) => pag.pagina).toList(),
    );
  }
}

class NavMenu {
  IconData icone;
  bool visivel;
  String titulo;
  Widget pagina;
  List<NavMenu> submenu;
  Function function;

  NavMenu(
      {@required this.icone, @required this.visivel, @required this.titulo, @required this.pagina, @required this.submenu, this.function});
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
