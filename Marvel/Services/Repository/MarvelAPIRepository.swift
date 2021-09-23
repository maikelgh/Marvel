//
//  MarvelAPIRepository.swift
//  Marvel
//
//  Created by michael on 12/9/21.
//

import Foundation
class MarvelAPIRepository: MarvelRepository {
    //Obtener listado.
    func getCharacters(data: AltaSimplificadaRequestVO?, result: @escaping (BaseResult<AltaSimplificadaResponseVO>) -> Void) {

        background {
            CustomLog.log(type: .info, category: .repository, item: "altaSimplificada called")

            RegistroSimplificadoControllerAPI.altaSimplificada(body: data) { (response, error) in
                ui {
                    guard let response = response else {

                        let err = BaseRepository.getCodeError(error)
                        CustomLog.log(type: .error, category: .repository, item: err.message)
                        result(BaseResult.failure(error: err))
                        return
                    }

                    CustomLog.log(type: .success, category: .repository, item: response)
                    result(BaseResult.success(result: response))
                }
            }
        }
    }

    //Obtener detalle.
    func getCharacter(data: ValidarIdentificadorRequestVO?, result: @escaping (BaseResult<ValidarIdentificadorResponseVO>) -> Void) {

        background {
            CustomLog.log(type: .info, category: .repository, item: "validarIdentificadorMacSimpl called")

            RegistroSimplificadoControllerAPI.validarIdentificadorMacSimpl(body: data) { (response, error) in
                ui {
                    guard let response = response else {

                        let err = BaseRepository.getCodeError(error)
                        CustomLog.log(type: .error, category: .repository, item: err.message)
                        result(BaseResult.failure(error: err))
                        return
                    }

                    CustomLog.log(type: .success, category: .repository, item: response)
                    result(BaseResult.success(result: response))
                }
            }
        }
    }
}

