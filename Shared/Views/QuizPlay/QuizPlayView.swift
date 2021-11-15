//
//  QuizPlayView.swift
//  Quiz SwiftUI (iOS)
//
//  Created by Javier García Céspedes on 23/9/21.
//

import SwiftUI

struct QuizPlayView: View {
    var quizItem : QuizItem
    
    @EnvironmentObject var scoresModel: ScoresModel //asigna el enviroment a este valor
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State var answer: String = ""
    @State var showAlert  = false
    @State var r_letras = 0.0
    @State var g_letras = 0.0
    @State var b_letras = 0.0
    
    
    
    var body: some View {
        
        if horizontalSizeClass == .compact{
            VStack{
                HStack{
                    Text(quizItem.question)
                        .font(.largeTitle)
                        .foregroundColor(Color(red: r_letras, green: g_letras, blue: b_letras))
                    Image(quizItem.favourite ? "star_yellow" : "star_grey")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .scaledToFit()
                        .contextMenu{
                            Button("Letras Rojas 🔴"){
                                r_letras = 255.0
                                g_letras = 0.0
                                b_letras = 0.0
                            }
                            Button("Letras Verdes 🟢"){
                                r_letras = 0.0
                                g_letras = 255.0
                                b_letras = 0.0
                                
                            }
                        }
                }
                VStack{
                    TextField("Respuesta",
                              text:$answer,
                              onCommit: {
                        showAlert = true
                    }
                    )
                        .foregroundColor(Color(red: r_letras, green: g_letras, blue: b_letras))
                        .alert(isPresented: $showAlert) {
                            scoresModel.check(respuesta: answer, quiz: quizItem)
                            let r1 = answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                            let r2 = quizItem.answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                            return Alert(title: Text("Resultado"),
                                         
                                         message: Text(r1==r2 ? "Respuesta Correcta" : "Respuesta Incorrecta"),
                                         dismissButton: .default(Text("Volver")))
                            
                        }
                }
                .padding()
                
                
                Button {
                    showAlert = true
                } label: {
                    Text("Comprobrar")
                }
                
                attachment
                author
                
                Text("Score: \(scoresModel.acertadas.count)")
                    .foregroundColor(Color(red: r_letras, green: g_letras, blue: b_letras))
                
                
            }
        }else{
            HStack{
                VStack{
                    HStack{
                        Text(quizItem.question)
                            .font(.largeTitle)
                            .foregroundColor(Color(red: r_letras, green: g_letras, blue: b_letras))
                        Image(quizItem.favourite ? "star_yellow" : "star_grey")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .scaledToFit()
                            .contextMenu{
                                Button("Letras Rojas 🔴"){
                                    r_letras = 255.0
                                    g_letras = 0.0
                                    b_letras = 0.0
                                }
                                Button("Letras Verdes 🟢"){
                                    r_letras = 0.0
                                    g_letras = 255.0
                                    b_letras = 0.0
                                    
                                }
                            }
                    }
                    Spacer()
                    TextField("Respuesta",
                              text:$answer,
                              onCommit: {
                        showAlert = true
                    }
                    )
                        .foregroundColor(Color(red: r_letras, green: g_letras, blue: b_letras))
                        .alert(isPresented: $showAlert) {
                            scoresModel.check(respuesta: answer, quiz: quizItem)
                            let r1 = answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                            let r2 = quizItem.answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                            return Alert(title: Text("Resultado"),
                                         
                                         message: Text(r1==r2 ? "Respuesta Correcta" : "Respuesta Incorrecta"),
                                         dismissButton: .default(Text("Volver")))
                            
                        }
                    Button {
                        showAlert = true
                    } label: {
                        Text("Comprobrar")
                    }
                    Spacer()
                    author
                    Text("Score: \(scoresModel.acertadas.count)")
                        .foregroundColor(Color(red: r_letras, green: g_letras, blue: b_letras))
                }
                VStack{
                    attachment
                    
                }
            }
        }
    }
    
    private var author: some View{
        let uurl = quizItem.author?.photo?.url
        let univm = NetworkImageViewModel(url: uurl)
        
        return HStack(alignment: .bottom, spacing: 5){
            Text(quizItem.author?.username ?? "Anónimo")
                .font(.callout)
                .foregroundColor(.green)
            
            
            NetworkImageView(viewModel: univm)
                .scaledToFill()
                .frame(width: 40, height: 40, alignment: .center)
                .clipShape(Circle())
                .overlay(Circle().stroke(lineWidth: 3))
                .contextMenu{
                    Button("Limpiar"){
                        answer = ""
                    }
                    Button("Respuesta"){
                        answer = quizItem.answer
                    }
                }
        }
    }
    
    @State var angle = 0.0 //por ser state tiene que ir fuera de la view
    @State var sat = 1.0
    
    private var attachment: some View{
        
        let aurl = quizItem.attachment?.url
        let anivm = NetworkImageViewModel(url: aurl)
        
        
        
        
        return GeometryReader { g in
            NetworkImageView(viewModel: anivm)
                .scaledToFill()
                .frame(width: g.size.width, height: g.size.height, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .contentShape(RoundedRectangle(cornerRadius: 10)) //importante para los giros de pantalla
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(.blue, lineWidth: 2))
                .saturation(sat)
                .rotationEffect(Angle(degrees: angle))
            
                .onTapGesture(count: 2) {
                    answer = quizItem.answer
                    withAnimation(.easeInOut(duration: 1.5)){
                        angle = angle+360
                        if sat == 1.0 {
                            sat = 0.0
                        } else if sat == 0.0 {
                            sat = 1.0
                        }
                    }
                }
        }
        .padding()
        
    }
}
//    struct QuizPlayView_Previews: PreviewProvider {
//        static var previews: some View {
//            QuizPlayView()
//        }
//    }
