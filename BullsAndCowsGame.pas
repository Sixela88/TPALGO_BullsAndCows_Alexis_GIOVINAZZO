unit BullsAndCowsGame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    E_MotSaisi: TEdit;
    L_VotreMot: TLabel;
    E_Bulls: TEdit;
    L_Bulls: TLabel;
    L_Cows: TLabel;
    E_Cows: TEdit;
    E_NbCarac: TEdit;
    L_NbCarac: TLabel;
    E_NbEssais: TEdit;
    E_GagnePerdu: TEdit;
    B_Check: TButton;
    B_Retry: TButton;
    B_Exit: TButton;
    L_NbEssais: TLabel;
    M_ListeMots: TMemo;
    M_MotAleatoire: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure B_RetryClick(Sender: TObject);
    procedure NombreEssaisEtCaractere(Sender:TObject);
    procedure B_ExitClick(Sender: TObject);
    procedure B_CheckClick(Sender: TObject);
    function ErreurSaisie(Sender:TObject):boolean;
    procedure BullsAndCows(Sender:TObject);
    PROCEDURE Victoire(Sender:TObject);

  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

//Bulls and Cows Game
{Demander un mot à l'utilisateur comparer ce mot avec les mots de notre fichier (10 max)
 la sélection du mot doit être aléatoire. Il faudra tester la saisie de l'utilisateur, les
 mots saisis en majuscules ne seront pas acceptés, les caractères spéciaux ne sont pas acceptés,
 les mots ne peuvent pas avoir plusieurs fois la même lettre et le mot à un nombre de caractères maximum.
 Il faut tester la longueur du mot saisi par l'utilisateur et lui indiquerai si le mot est trop petit ou
 si le mot est trop grand.
 Le joueur a un nombre d'essais maximum en fonction de la taille du mot. S'il y a une erreur de saisie,
 la saisie ne sera pas compté comme un essai.
 On doit utiliser les tailles de mot suivantes 3,4,5,6,7 (2 mots de chaque) et pour chaque taille de mot,
 un nombre d'essais différents 4,7,10,16,20.
 Le joueur peut recommencer et quitter.}

//Utiliser des types énumérés

PROCEDURE TForm1.NombreEssaisEtCaractere(Sender:TObject);
//Fonction définissant le nombre d'essais possibles en fonction de la taille du mot.
Var
  Longueur:integer;

begin
  Longueur:=length(M_MotAleatoire.Text);
  case Longueur of
  3 :
  begin
        E_NbEssais.Text:='4';
        E_NbCarac.Text:=IntToStr(Longueur);
  end;

  4 :
  begin
        E_NbEssais.Text:='7';
        E_NbCarac.Text:=IntToStr(Longueur);
  end;

  5 :
  begin
        E_NbEssais.Text:='10';
        E_NbCarac.Text:=IntToStr(Longueur);
  end;

  6 :
  begin
        E_NbEssais.Text:='16';
        E_NbCarac.Text:=IntToStr(Longueur);
  end;

  7 :
  begin
        E_NbEssais.Text:='20';
        E_NbCarac.Text:=IntToStr(Longueur);
  end;

  end;

end;

PROCEDURE TForm1.BullsAndCows(Sender:TObject);
{Donne au joueur les lettres placées au bon endroit et les lettres présentes dans le mot mais pas
placées au bon endroit}

VAR
  Longueur:integer;
  ChaineTest:string;
  MotAleatoire:string;
  i,j:integer;

begin
  MotAleatoire:=M_MotAleatoire.Text;
  ChaineTest:=E_MotSaisi.Text;
  Longueur:=length(ChaineTest);
  for i := 1 to Longueur do
    begin
      for j := 1 to Longueur do
        begin
           if (ChaineTest[i]= MotAleatoire[j]) AND (i=j) then
            E_Cows.Text:=IntToStr(StrToInt(E_Cows.Text)+1)
           else
            if (ChaineTest[i]= MotAleatoire[j]) AND (i<>j) then
              E_Bulls.Text:=IntToStr(StrToInt(E_Bulls.Text)+1);
        end;
    end;

end;

FUNCTION TForm1.ErreurSaisie(Sender:TObject):boolean;
{Vérifie que le joueur n'a pas saisi un mot en majuscule, avec chiffres, des espaces , des lettres
identiques ou un mot trop long ou trop court}

VAR
  Longueur:integer;
  ChaineTest:string;
  i,j,k:integer;
  Erreur:boolean;
  ErreurLong:boolean;

begin
  Erreur:=FALSE;
  ErreurLong:=FALSE;
  ChaineTest:=E_MotSaisi.Text;
  Longueur:=length(ChaineTest);

//Vérification de la saisie.
  for i := 1 to Longueur do
      begin
        if (((Ord(ChaineTest[i])>=97) AND (Ord(ChaineTest[i])<=122))) then
          begin
            if Longueur<>length(M_MotAleatoire.Text) then
              begin
                Erreur:=TRUE;
                ErreurLong:=TRUE;
              end
          end
        else
          Erreur:=TRUE;
      end;

  for j := 1 to Longueur do
    begin
      for k := 1 to Longueur do
        begin
          if (ChaineTest[j]= ChaineTest[k]) AND (j<>k) then
          Erreur:=TRUE;
        end;
    end;

//Affichage de l'erreur à l'utilisateur
  IF Erreur=FALSE then
    begin
      ErreurSaisie:=FALSE;
    end
  else
      begin
        ErreurSaisie:=TRUE;
        if ErreurLong=TRUE then
          begin
            if Longueur>length(M_MotAleatoire.Text) then
              begin
                with Application do
                  begin
                    NormalizeTopMosts;
                    MessageBox('Mot saisi trop long',' ',MB_OK);
                    RestoreTopMosts;
                  end;
              end;
            if Longueur<length(M_MotAleatoire.Text) then
              begin
                with Application do
                  begin
                    NormalizeTopMosts;
                    MessageBox('Mot saisi trop court',' ',MB_OK);
                    RestoreTopMosts;
                  end;
              end;
          end;

        if ErreurLong=FALSE then
          begin
            with Application do
              begin
                NormalizeTopMosts;
                MessageBox('Erreur',' ',MB_OK);
                RestoreTopMosts;
              end;
          end;

      end;
end;

PROCEDURE TForm1.B_CheckClick(Sender: TObject);
//Procedure de vérification lors du clic lorsqu'un mot est saisi
VAR
  ErreurMotSaisi:boolean;
  Vict:boolean;
  Def:boolean;

begin
  ErreurMotSaisi:=ErreurSaisie(Sender);
  if ErreurMotSaisi=FALSE then
    begin
      E_NbEssais.Text:=IntToStr(StrToInt(E_NbEssais.Text)-1);
      E_Bulls.Text:='0';
      E_Cows.Text:='0';
      BullsAndCows(Sender);
      Victoire(Sender); //Appel de la procédure victoire
    end;

end;

PROCEDURE TForm1.B_ExitClick(Sender: TObject);
//Procédure se déclenchant lorsque le joueur appuie sur 'Quitter' et permet de quitter le jeu.
begin
  with Application do
    begin
      NormalizeTopMosts;
      if(MessageBox('Voulez-vous quitter ?','Quitter',MB_YESNO)=IDYES)then
        close;
      RestoreTopMosts;
    end;
end;

PROCEDURE TForm1.B_RetryClick(Sender: TObject);
//Lorsque le joueur clic sur 'Recommencer' on appelle la procédure FormCreate
begin
  FormCreate(Sender);
end;

PROCEDURE TForm1.FormCreate(Sender:TObject);
{Initialisation des différents cellules de saisies et d'affichages
Choix d'un mot aléatoire dans la liste du fichier
Calcul du nombre d'essais.}

Var
  NbRandom:integer;
  LignesFichier:integer;
  Longueur:integer;

BEGIN
  E_GagnePerdu.Visible:=FALSE;
  E_GagnePerdu.Text:='';
  E_MotSaisi.Enabled:=TRUE;
  E_NbEssais.Text:='0';
  B_Check.Enabled:=TRUE;
  E_Cows.Text:='0';
  E_Bulls.Text:='0';
  E_MotSaisi.Text:='Saisir votre mot';    //La case indique qu'il faut saisir un mot
  M_ListeMots.Text:=''; //La liste de mots est vidée
  M_MotAleatoire.Text:=''; //Le mot aléatoire est vidée
  M_ListeMots.Lines.LoadFromFile('C:/mots.txt'); //Chargement du fichier de mots
  //E_MotSaisi.SetFocus;

  //Choix d'un mot aléatoirement parmi la liste du fichier.
  randomize;
  LignesFichier:=M_ListeMots.Lines.Count;
  NbRandom:=random((LignesFichier));
  M_MotAleatoire.Text:=M_ListeMots.Lines[NbRandom];

  //Appel de la procédure NombreEssaisEtCaractere
  NombreEssaisEtCaractere(Sender);
END;

PROCEDURE TForm1.Victoire(Sender:TObject);
//Verifie la condition de victoire
VAR
  vict,def:boolean;
  Longueur:integer;
  Essais:integer;

begin
  vict:=FALSE;
  Longueur:=length(M_MotAleatoire.Text);


  //Vérifie si le nombre de Cows est égal à la longueur du mot si oui alors le joueur gagne.
  if E_Cows.Text=IntToStr(Longueur) then
    vict:=TRUE
  else
    vict:=FALSE;

  if vict=TRUE then //Si victoire alors le jeu se bloque et il affiche gagné
    begin
      E_GagnePerdu.Text:='Victoire';
      E_MotSaisi.Enabled:=FALSE;
      B_Check.Enabled:=FALSE;
      E_GagnePerdu.Visible:=TRUE;
    end;

  Essais:=StrToInt(E_NbEssais.Text);
  if ((vict=FALSE) AND (Essais=0)) then //Si défaite alors le jeu se bloque et il affiche perdu
    begin   //Problème affectant cette instruction qui m'affiche tous le temps perdu dès lors qu'il ya une erreur
      E_GagnePerdu.Text:='Perdu';
      E_MotSaisi.Enabled:=FALSE;
      B_Check.Enabled:=FALSE;
      E_GagnePerdu.Visible:=TRUE;
    end;

end;

end.
