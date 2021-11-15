//
//  ContentView.swift
//  Shared
//
//  Created by Javier García Céspedes on 21/9/21.
//

import SwiftUI

struct QuizzesListView: View {
    
    @EnvironmentObject var quizzesModel: QuizzesModel //asigna el enviroment a este valor. Usamos esta clase en varios sitios
    @EnvironmentObject var scoresModel: ScoresModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    
    @State var verTodo: Bool = true
    
    var body: some View { //body = donde se contruye la interfaz usuario. Con este código mostramos la lista de quizzes
        NavigationView { //vista de navegación de la app. Es clave. Es donde se representarán todos los quizzes
            List{
                Toggle("Ver Todo", isOn: $verTodo .animation())
                ForEach(quizzesModel.quizzes){ qi in //recorremos todos los quizzes y los mostramos por pantalla
                    if verTodo || !scoresModel.acertada(qi){
                        NavigationLink { //enlace para acceder a otra pantalla. Me muestra un link para acceder a la vista play.
                            QuizPlayView(quizItem: qi)
                        } label: {
                            QuizRowView(quizItem: qi)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Quizz con SwiftUI. Práctica 2"))
            .navigationBarItems(leading: Text("Record:\(scoresModel.record.count)").font(.callout))
            .onAppear(perform: {
                quizzesModel.load()
            })
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuizzesListView()
//    }
//}
