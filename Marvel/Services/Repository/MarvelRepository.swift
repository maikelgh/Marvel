//
//  MarvelRepository.swift
//  Marvel
//
//  Created by michael on 12/9/21.
//

import Foundation

protocol MarvelRepository {

    func getCharacters(data: AltaSimplificadaRequestVO?, result: @escaping (BaseResult<AltaSimplificadaResponseVO>) -> Void)

    func getCharacter(data: ValidarIdentificadorRequestVO?, result: @escaping (BaseResult<ValidarIdentificadorResponseVO>) -> Void)
}

